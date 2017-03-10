//
// Wire
// Copyright (C) 2017 Wire Swiss GmbH
//
// This program is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
//
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
// GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License
// along with this program. If not, see http://www.gnu.org/licenses/.
//

import CoreData


open class ToDoItem: ZMManagedObject {
    
    @NSManaged open internal (set) var text: String?
    @NSManaged open internal (set) var message: ZMMessage?
    @NSManaged open internal (set) var isDone: Bool
    @NSManaged open internal (set) var dueDate: Date?

    override open class func entityName() -> String {
        return "ToDoItem"
    }
    
    open override var modifiedKeys: Set<AnyHashable>? {
        get {
            return Set()
        } set {
            // do nothing
        }
    }
    
    public static func addToDo(for message: ZMConversationMessage?,
                        atDate date: Date?,
                        withDescription text: String?,
                        inUserSession contextProvider: ZMManagedObjectContextProvider) -> ToDoItem?
    {
        let msg = message as? ZMMessage
        guard message == nil || msg != nil else { return nil }
        
        return self.addToDo(for: msg, atDate: date, withDescription: text, inContext: contextProvider.managedObjectContext)
    }
    
    private static func addToDo(for message: ZMMessage?,
                        atDate date: Date?,
                        withDescription text: String?,
                        inContext context: NSManagedObjectContext) -> ToDoItem?
    {
        guard message != nil || text != nil else { return nil }
        
        let item = insertNewObject(in: context)
        item.dueDate = date
        item.text = text
        item.message = message
        return item
    }
    
    public func markAsDone(){
        self.isDone = true
    }
    
    public func delete(inUserSession userSession: ZMManagedObjectContextProvider) {
        userSession.managedObjectContext.delete(self)
    }
    
    public static func allItems(inUserSession userSession: ZMManagedObjectContextProvider) -> [ToDoItem] {
        guard let uiMOC = userSession.managedObjectContext else { return [] }
        let fetchRequest = NSFetchRequest<ToDoItem>(entityName: self.entityName())
        let items = uiMOC.fetchOrAssert(request: fetchRequest)
        return items
    }
    
    public func reschedule(newDate: Date) {
        if dueDate == nil || dueDate!.compare(newDate) != .orderedSame {
            dueDate = newDate
        }
    }
    
}
