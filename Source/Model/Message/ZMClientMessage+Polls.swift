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

extension ZMGenericMessageData {
    var pollVote: ZMPollVote? {
        guard let genericMessage = self.genericMessage, genericMessage.hasPoll() else { return nil }
        guard let pollEntry = genericMessage.poll else { return nil }
        guard let vote = pollEntry.vote, pollEntry.hasVote() else { return nil }
        return vote
    }
    
    var pollContent: ZMPollContent? {
        guard let genericMessage = self.genericMessage, genericMessage.hasPoll() else { return nil }
        guard let pollEntry = genericMessage.poll else { return nil }
        guard let pollContent = pollEntry.content, pollEntry.hasContent() else { return nil }
        return pollContent
    }
}

extension ZMPollMessageData {
    convenience init?(messageData: [ZMGenericMessageData], message: ZMClientMessage) {
        var content: ZMPollContent? = nil
        var castedVotes = [Int : Set<ZMUser>]()
        for message in messageData {
            if let pollContent = message.pollContent {
                content = pollContent
            } else if let vote = message.pollVote {
                let answer = Int(vote.votedOption)
                var users = castedVotes[answer] ?? Set<ZMUser>()
                users.insert(message.sender)
                castedVotes[answer] = users
            }
        }
        guard let pollContent = content else { return nil }
        guard let entries = pollContent.options as? [String] else { return nil }
        
        let votes = castedVotes.mapKeys { voteIdx -> String in
            return entries[voteIdx]
        }
        
        self.init(question: pollContent.question, entries: entries, votes: votes, message: message)
    }
}

extension ZMClientMessage {
    override public var pollMessageData: ZMPollMessageData? {
        guard let genericMessages = dataSet.array as? [ZMGenericMessageData] else { return nil }
        return ZMPollMessageData(messageData: genericMessages, message: self)
    }
    
    public var currentVoteMessageData: ZMGenericMessageData? {
        guard let genericMessages = dataSet.array as? [ZMGenericMessageData] else { return nil }
        let selfUser = ZMUser.selfUser(in: managedObjectContext!)
        for message in genericMessages {
            if let _ = message.pollVote, message.sender == selfUser {
                return message
            }
        }
        return nil
    }
}
