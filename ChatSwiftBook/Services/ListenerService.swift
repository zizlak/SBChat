//
//  ListenerService.swift
//  ChatSwiftBook
//
//  Created by Aleksandr Kurdiukov on 31.07.21.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth

class ListenerService {
    
    //MARK: - Singeltone
    static let shared = ListenerService()
    private init() {}
    
    private var db = Firestore.firestore()
    
    
    private var userRef: CollectionReference {
        db.collection(K.users)
    }
    
    private var currentID: String? {
        Auth.auth().currentUser?.uid
    }
    
    func usersObserve(users: [MUser], completion: @escaping(Result<[MUser], Error>) -> ()) -> ListenerRegistration? {
        var users = users
        
        let usersListener = userRef.addSnapshotListener { snapshot, error in
            
            guard let snapshot = snapshot else { completion(.failure(error!)); return }
            
            
            snapshot.documentChanges.forEach { diff in
                guard let user = MUser(doc: diff.document) else { return }
                
                switch diff.type {
                
                case .added:
                    guard !users.contains(user), user.id != self.currentID else { return }
                    users.append(user)
                    
                case .modified:
                    guard let index = users.firstIndex(of: user) else { return }
                    users[index] = user
                    
                case .removed:
                    guard let index = users.firstIndex(of: user) else { return }
                    users.remove(at: index)
                }
            }
            completion(.success(users))
        }
        return usersListener
    }
    
    func waitingChatsObserve(chats: [MChat], completion: @escaping(Result<[MChat], Error>) -> ()) -> ListenerRegistration? {
        
        var chats = chats
        let chatsRef = db.collection([K.users, currentID!, K.waitingChats].joined(separator: "/"))
        
        let chatsListener = chatsRef.addSnapshotListener { snapshot, error in
            guard let snapshot = snapshot else {
                completion(.failure(error!))
                return }
            
            snapshot.documentChanges.forEach { diff in
                guard let chat = MChat(doc: diff.document) else { print("init error"); return }
                
                switch diff.type {
                
                case .added:
                    guard !chats.contains(chat) else { return }
                    chats.append(chat)
                    
                case .modified:
                    guard let index = chats.firstIndex(of: chat) else { return }
                    chats[index] = chat
                    
                case .removed:
                    guard let index = chats.firstIndex(of: chat) else { return }
                    chats.remove(at: index)
                }
            }

            completion(.success(chats))
        }
        return chatsListener
    }
    
    
    func activeChatsObserve(chats: [MChat], completion: @escaping(Result<[MChat], Error>) -> ()) -> ListenerRegistration? {
        
        var chats = chats
        let chatsRef = db.collection([K.users, currentID!, K.activeChats].joined(separator: "/"))
        
        let chatsListener = chatsRef.addSnapshotListener { snapshot, error in
            guard let snapshot = snapshot else { completion(.failure(error!)); return }
            
            snapshot.documentChanges.forEach { diff in
                guard let chat = MChat(doc: diff.document) else { print("MChat init error"); return }
                
                switch diff.type {
                
                case .added:
                    guard !chats.contains(chat) else { return }
                    chats.append(chat)
                    
                case .modified:
                    guard let index = chats.firstIndex(of: chat) else { return }
                    chats[index] = chat
                    
                case .removed:
                    guard let index = chats.firstIndex(of: chat) else { return }
                    chats.remove(at: index)
                }
            }

            completion(.success(chats))
        }
        return chatsListener
    }
    
    
    //MARK: - MessageListener
    func messageObserve(chat: MChat, completion: @escaping(Result<MMessage, Error>) -> ()) -> ListenerRegistration? {
       // let ref = userRef.document([currentID!, K.activeChats, chat.friendId, K.messages].joined(separator: "/"))
        
        let ref1 = userRef.document(currentID!).collection(K.activeChats).document(chat.friendId).collection(K.messages)
        
        let messageListener = ref1.addSnapshotListener { snapshot, error in
            guard let snapshot = snapshot else { completion(.failure(error!)); return }
            
            snapshot.documentChanges.forEach { diff in
                guard let message = MMessage(doc: diff.document) else { return }
                
                switch diff.type {
                
                case .added:
                    completion(.success(message))
                case .modified:
                    break
                case .removed:
                    break
                }
            }
        }
        return messageListener
    }
}
