//
// Wire
// Copyright (C) 2016 Wire Swiss GmbH
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

import Foundation

public let ZMReactionUnicodeValueKey    = "unicodeValue"
public let ZMReactionMessageValueKey    = "message"
public let ZMReactionUsersValueKey      = "users"

@objc public enum TransportReaction : UInt32 {
    case none  = 0
    case heart = 1
}


open class Reaction : ZMManagedObject {
    
    @NSManaged var unicodeValue : String?
    @NSManaged var message      : ZMMessage?
    @NSManaged var users        : Set<ZMUser>
    
    
    open static func insertReaction(_ unicodeValue: String, users: [ZMUser], inMessage message: ZMMessage) -> Reaction {
        let reaction = insertNewObject(in: message.managedObjectContext!)
        reaction.message = message
        reaction.unicodeValue = unicodeValue
        reaction.mutableSetValue(forKey: ZMReactionUsersValueKey).addObjects(from: users)
        return reaction
    }
    
    
    open override func keysTrackedForLocalModifications() -> Set<String> {
        return [ZMReactionUsersValueKey]
    }
    
    open override static func entityName() -> String {
        return "Reaction"
    }
    
    open override static func sortKey() -> String? {
        return ZMReactionUnicodeValueKey
    }
    
    @objc public static func transportReaction(from unicode: String) -> TransportReaction {
        switch unicode {
        case MessageReaction.like.unicodeValue:
            return .heart
        default:
            return .none
        }

    }
    
}
