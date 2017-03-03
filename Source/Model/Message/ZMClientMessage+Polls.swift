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

extension ZMPollMessageData {
    convenience init?(messageData: [ZMGenericMessageData]) {
        
//        guard let pollMessages = messageData.flatMap { $0 }
//        else { return nil }
        let pollEntries = messageData.flatMap { $0.genericMessage }.filter { $0.hasPoll() }.flatMap { $0.poll }
        guard !pollEntries.isEmpty else { return nil }
        
        var content: ZMPollContent? = nil
        var votes = [ZMPollVote]()
        for pollEntry in pollEntries {
            if let pollContent = pollEntry.content, pollEntry.hasContent() {
                content = pollContent
            } else if let vote = pollEntry.vote, pollEntry.hasVote() {
                votes.append(vote)
            }
        }
        guard let pollContent = content else { return nil }
        
        return nil
        
        
//        self.init(entries)
    }
}

extension ZMClientMessage {
    override public var pollMessageData: ZMPollMessageData? {
        guard let genericMessages = dataSet.array as? [ZMGenericMessageData] else { return nil }
//        return ZMPollMessageData(pollMessageData: genericMessages)
        
        
//        for data in dataSet {
//            data.geri
//        }
//        guard let genericMessage = self.genericMessage else { return nil }

        return nil
    }
}
