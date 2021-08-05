//
//  MChat.swift
//  ChatSwiftBook
//
//  Created by Aleksandr Kurdiukov on 03.07.21.
//

import Foundation
import FirebaseFirestore

struct MChat: Hashable, Decodable {
    var friendId: String
    var friendUsername: String
    var friendAvatarStringURL: String
    var lastMessageContent: String
    
    //MARK: - init
    init?(doc: DocumentSnapshot) {
        guard let data = doc.data() else { return nil }
        
        guard let friendUsername = data["friendUsername"] as? String else { return nil }
        guard let friendId = data["friendId"] as? String else { return nil }
        guard let friendAvatarStringURL = data["friendAvatarStringURL"] as? String else { return nil }
        guard let lastMessageContent = data["lastMessage"] as? String else { return nil }
        
        self.friendId = friendId
        self.friendUsername = friendUsername
        self.friendAvatarStringURL = friendAvatarStringURL
        self.lastMessageContent = lastMessageContent
    }
    
    init(friendID: String, friendUsername: String, friendAvatarStringURL: String, lastMessageContent: String) {
        self.friendId = friendID
        self.friendUsername = friendUsername
        self.friendAvatarStringURL = friendAvatarStringURL
        self.lastMessageContent = lastMessageContent
    }
    
    //MARK: - Dict
    var representation: [String : Any] {
        var rep = [String : Any]()
        rep["friendUsername"] = friendUsername
        rep["friendAvatarStringURL"] = friendAvatarStringURL
        rep["lastMessage"] = lastMessageContent
        rep["friendId"] = friendId
        return rep
    }
    
    
    
        //MARK: - MirrirChat
    func mirrorChatFor(currentUser: MUser) -> MChat {
        MChat(friendID: currentUser.id, friendUsername: currentUser.username, friendAvatarStringURL: currentUser.avatarStringURL, lastMessageContent: self.lastMessageContent)
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(friendId)
    }

    static func == (lhs: MChat, rhs: MChat) -> Bool {
        return lhs.friendId == rhs.friendId
    }
}
