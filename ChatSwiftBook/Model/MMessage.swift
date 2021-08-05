//
//  MMessage.swift
//  ChatSwiftBook
//
//  Created by Aleksandr Kurdiukov on 03.08.21.
//

import UIKit
import FirebaseFirestore
import MessageKit

struct MMessage: Hashable, MessageType {
    
    //MARK: - Properies
    
    var sender: SenderType
    
    let id: String?
    let content: String
    let sentDate: Date
    
    var messageId: String {
        id ?? UUID().uuidString
    }
    
    var kind: MessageKind {
        if let image = image {
            let mediaItem = ImageMediaItem(url: nil, image: nil, placeholderImage: image, size: image.size)
            return .photo(mediaItem)
        } else {
           return .text(content)
        }
        
    }
    
    var image: UIImage? = nil
    
    var downloadURL: URL? = nil
    
    
    
    //MARK: - Init
    init(user: MUser, content: String) {
        sender = Sender(senderId: user.id, displayName: user.username)
        self.content = content
        sentDate = Date()
        id = nil
    }
    
    init?(doc: QueryDocumentSnapshot) {
        let data = doc.data()

        guard let senderID = data["senderID"] as? String else { return nil }
        guard let senderName = data["senderName"] as? String else { return nil }
        self.sender = Sender(senderId: senderID, displayName: senderName)

        guard let created = data["created"] as? Timestamp else { return nil }
        self.sentDate = created.dateValue()
        
        self.id = doc.documentID
        
        if let content = data["content"] as? String {
            self.content = content
            downloadURL = nil
        } else if let urlString = data["url"] as? String, let url = URL(string: urlString) {
            downloadURL = url
            self.content = ""
        } else {
            return nil
        }
    }
    
    
    init(user: MUser, image: UIImage) {
        sender = Sender(senderId: user.id, displayName: user.username)
        self.image = image
        content = ""
        sentDate = Date()
        id = nil
    }
    
    
    //MARK: - Dict
    var representation: [String : Any] {
        
        var rep = [String : Any]()
        rep["created"] = sentDate
        rep["senderID"] = sender.senderId
        rep["senderName"] = sender.displayName
        
        if let url = downloadURL {
            rep["url"] = url.absoluteString
        } else {
            rep["content"] = content
        }
        
        return rep
    }
    
    
    
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(messageId)
    }
    
    static func == (lhs: MMessage, rhs: MMessage) -> Bool {
        return lhs.messageId == rhs.messageId
    }
    
}


//MARK: - Comparable
extension MMessage: Comparable {
    static func < (lhs: MMessage, rhs: MMessage) -> Bool {
        lhs.sentDate < rhs.sentDate
    }
    
}
