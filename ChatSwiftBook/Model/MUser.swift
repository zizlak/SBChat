//
//  MUser.swift
//  ChatSwiftBook
//
//  Created by Aleksandr Kurdiukov on 14.07.21.
//

import Foundation
import FirebaseFirestore

struct MUser: Hashable, Decodable {
    
    //MARK: - Properties
    var username: String
    var avatarStringURL: String
    var id: String
    
    var description: String
    var gender: String
    
    
    //MARK: - Init
    
    
    init?(doc: DocumentSnapshot) {
        
        guard let data = doc.data() else { return nil }
        
        guard let username = data["username"] as? String else { return nil }
        guard let id = data["id"] as? String else { return nil }
        guard let avatarStringURL = data["avatarStringURL"] as? String else { return nil }
        guard let description = data["description"] as? String else { return nil }
        guard let gender = data["gender"] as? String else { return nil }
        
        self.username = username
        self.id = id
        self.avatarStringURL = avatarStringURL
        self.description = description
        self.gender = gender
    }
    
    
    init?(doc: QueryDocumentSnapshot) {
        
        let data = doc.data()
        
        guard let username = data["username"] as? String else { return nil }
        guard let id = data["id"] as? String else { return nil }
        guard let avatarStringURL = data["avatarStringURL"] as? String else { return nil }
        guard let description = data["description"] as? String else { return nil }
        guard let gender = data["gender"] as? String else { return nil }
        
        self.username = username
        self.id = id
        self.avatarStringURL = avatarStringURL
        self.description = description
        self.gender = gender
    }
    
    
    init(username: String, avatarStringURL: String, id: String, description: String, gender: String) {
        self.username = username
        self.id = id
        self.avatarStringURL = avatarStringURL
        self.description = description
        self.gender = gender
    }
    
    
    
    func contains(filter: String?) -> Bool {
        guard let filter = filter, !filter.isEmpty else { return true }
        
        return username.lowercased().contains(filter.lowercased())
    }
    
    
    var dict: [String: Any] {
        var rep: [String : Any] = ["id" : id]
        
        rep ["username"] = username
        rep ["avatarStringURL"] = avatarStringURL
        rep ["description"] = description
        rep ["gender"] = gender
        
        return rep
    }
    
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func == (lhs: MUser, rhs: MUser) -> Bool {
        return lhs.id == rhs.id
    }
}
