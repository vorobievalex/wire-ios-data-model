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
import ZMProtos

public final class PollEntry: NSObject {
    public let option: String
    public let users: [ZMUser]
    
    public init(option: String, users: [ZMUser]) {
        self.option = option
        self.users = users
        super.init()
    }
}

@objc public protocol ZMPollMessageData: NSObjectProtocol {
    var entries: [PollEntry] { get }
}

extension ZMConversation {
    public func appendPoll(options: [String]) -> ZMConversationMessage? {
        guard let content = ZMPollContent.builder().setOptionsArray(options) else { return nil }
        guard let poll = ZMPoll.builder().setContent(content) else { return nil }
        guard let message = ZMGenericMessage.builder().setPoll(poll).setMessageId(UUID().transportString()).build() else { return nil }
        return append(message, expires: false, hidden: false)
    }
}
