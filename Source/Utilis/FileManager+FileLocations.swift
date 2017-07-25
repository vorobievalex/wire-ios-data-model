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

import Foundation
import WireSystem

private let zmLog = ZMSLog(tag: "FileLocation")

public extension FileManager {
    /// Creates a new directory if needed, sets the file protection to `completeUntilFirstUserAuthentication` and excludes the URL from backups
    public func createAndProtectDirectory(at directoryURL: URL) {
        if !fileExists(atPath: directoryURL.path) {
            do {
                try createDirectory(at: directoryURL, withIntermediateDirectories: true, attributes: nil)
            }
            catch let error {
                fatal("Failed to create directory: \(directoryURL), error: \(error)")
            }
        }
        
        // Make sure it's not accessible until first unlock
        do {
            let attributes = [FileAttributeKey.protectionKey: FileProtectionType.completeUntilFirstUserAuthentication]
            try setAttributes(attributes, ofItemAtPath: directoryURL.path)
        }
        catch let error {
            fatal("Failed to set protection until first user authentication: \(directoryURL), error: \(error)")
        }
        
        // Make sure this is not backed up:
        directoryURL.excludeFromBackup()
    }
}



public extension URL {
    
    public func excludeFromBackup() {
        var mutableCopy = self
        do {
            var resourceValues = URLResourceValues()
            resourceValues.isExcludedFromBackup = true
            try mutableCopy.setResourceValues(resourceValues)
        }
        catch let error {
            fatal("Error excluding: \(mutableCopy), from backup: \(error)")
        }
    }
    
    public var isExcludedFromBackup : Bool {
        guard let values = try? resourceValues(forKeys: Set(arrayLiteral: .isExcludedFromBackupKey)) else { return false }
        return values.isExcludedFromBackup ?? false
    }
}



