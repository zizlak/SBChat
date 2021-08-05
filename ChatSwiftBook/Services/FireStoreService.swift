//
//  FireStoreManager.swift
//  ChatSwiftBook
//
//  Created by Aleksandr Kurdiukov on 28.07.21.
//

import Foundation
import Firebase
import FirebaseAuth
import FirebaseFirestore
import GoogleSignIn

class FireStoreService {
    
    //MARK: - Singeltone
    
    static let shared = FireStoreService()
    private init() {}
    
    
    
    //MARK: - Properties
    
    let db = Firestore.firestore()
    
    private var userRef: CollectionReference { db.collection(K.users) }
    private var currentUser: MUser!
    private var waitingChatsRef: CollectionReference {
        db.collection([K.users, currentUser.id, K.waitingChats].joined(separator: "/"))
    }
    
    private var activeChatsRef: CollectionReference {
        db.collection([K.users, currentUser.id, K.activeChats].joined(separator: "/"))
    }
    
    
    //MARK: - saveProfile
    
    func saveProfile(id: String, userName: String?, email: String, avatarImage: UIImage?, description: String?, gender: String?, completion: @escaping(Result<MUser, Error>) -> ()) {
        
        guard Validators.isFilled(userName: userName, description: description, gender: gender) else {
            completion(.failure(ChatError.emptyFields))
            return }
        guard let avatarImage = avatarImage, avatarImage != #imageLiteral(resourceName: "avatar-3"), avatarImage != #imageLiteral(resourceName: "avatar-4") else {
            completion(.failure(ChatError.imageNotExist)); return }
        
        
        var muser = MUser(username: userName!, avatarStringURL: "", id: id, description: description!, gender: gender!)
        
        StorageService.shared.upload(photo: avatarImage) { result in
            switch result {
            
            case .success(let url):
                muser.avatarStringURL = url.absoluteString
                self.userRef.document(muser.id).setData(muser.dict) { error in
                    if let error = error {
                        print(#function)
                        completion(.failure(error))
                    } else {
                        completion(.success(muser))
                    }
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
        
        
    }
    
    
    func getUserData(user: User, completion: @escaping(Result<MUser, Error>) -> ()) {
        let docRef = userRef.document(user.uid)
        
        docRef.getDocument { doc, error in
            if let error = error {
                completion(.failure(error))
            } else {
                guard let doc = doc, doc.exists else {
                    completion(.failure(ChatError.usrDoesntExist)); return
                }
                guard let muser = MUser(doc: doc) else {
                    completion(.failure(ChatError.usrDoesntExist)); return
                }
                self.currentUser = muser
                completion(.success(muser))
                
            }
        }
    }
    
    
    //MARK: - googleLogin
    func googleLogin(user: GIDGoogleUser!, error: Error!, completion: @escaping(Result<User, Error>) -> ()) {
        if let error = error {
            completion(.failure(error))
            return }
        
        guard
            let authentication = user?.authentication,
            let idToken = authentication.idToken
        else {print("authentication or idToken are nil"); return }
        
        let credential = GoogleAuthProvider.credential(withIDToken: idToken,
                                                       accessToken: authentication.accessToken)
        
        Auth.auth().signIn(with: credential) { authResult, error in
            if let error = error {
                completion(.failure(error))
                print("Auth.auth().signIn Error", error)
                return
            }
            guard let authResult = authResult else { return }
            completion(.success(authResult.user))
        }
    }
    
    
    //MARK: - WatingChats
    
    func createWatingChats(message: String, reciever: MUser, completion: @escaping(Result<Void, Error>) -> ()) {
        let ref = db.collection([K.users, reciever.id, K.waitingChats].joined(separator: "/"))
        
        // or the same::
      //  let ref1 = userRef.document(reciever.id).collection("waitingChats")

        
        let message = MMessage(user: currentUser, content: message)
        let chat = MChat(friendID: currentUser.id,
                         friendUsername: currentUser.username,
                         friendAvatarStringURL: currentUser.avatarStringURL,
                         lastMessageContent: message.content)
        
        //.document(id).setData - we can define id
        ref.document(currentUser.id).setData(chat.representation) { error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            let messageRef = ref.document(self.currentUser.id).collection("messages")
            
            // .addDocument - automatic id
            messageRef.addDocument(data: message.representation) { error in
                if let error = error {
                    completion(.failure(error))
                    return
                }
                completion(.success(Void()))
            }
        }
    }
    
    
    //MARK: - Delete
    
    func delete(chat: MChat, completion: @escaping(Result<Void, Error>) -> ()) {
        waitingChatsRef.document(chat.friendId).delete { error in
            if let error = error {
                completion(.failure(error))
            }
            self.deleteMessages(chat: chat, completion: completion)
        }
    }
    
    private func deleteMessages(chat: MChat, completion: @escaping(Result<Void, Error>) -> ()) {
        let ref = waitingChatsRef.document(chat.friendId).collection("messages")
        
        getWaitingChatMessages(chat: chat) { result in
            switch result {
            
            case .success(let messages):
                for message in  messages {
                    guard let docID = message.id else { return }
                    ref.document(docID).delete() {error in
                        if let error = error {
                            completion(.failure(error))
                        }
                        completion(.success(Void()))
                    }
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    
    private func getWaitingChatMessages(chat: MChat, completion: @escaping(Result<[MMessage], Error>) -> ()) {
        let ref = waitingChatsRef.document(chat.friendId).collection("messages")
        var messages = [MMessage]()
        ref.getDocuments { snapshot, error in
            if let error = error {
                completion(.failure(error))
            }
            
            for doc in snapshot!.documents {
                guard let message = MMessage(doc: doc) else { return }
                messages.append(message)
            }
            
            completion(.success(messages))
        }
        
    }
    
    //MARK: - MoveToActive
    
    func changeToActive(chat: MChat, completion: @escaping(Result<Void, Error>) -> ()) {
        getWaitingChatMessages(chat: chat) { result in
            switch result {
            
            case .success(let messages):
                self.delete(chat: chat) { result in
                    switch result {
                    
                    case .success:
                        self.createActive(chat: chat, messages: messages) { result in
                            switch result {
                            
                            case .success:
                                completion(.success(Void()))
                            case .failure(let error):
                                completion(.failure(error))
                            }
                        }
                    case .failure(let error):
                        completion(.failure(error))
                    }
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    
    private func createActive(chat: MChat, messages: [MMessage], completion: @escaping(Result<Void, Error>) -> ()) {
        activeChatsRef.document(chat.friendId).setData(chat.representation) { error in
            if let error = error {
                completion(.failure(error))
                return
            }
            let messageRef = self.activeChatsRef.document(chat.friendId).collection("messages")
            for message in messages {
                messageRef.addDocument(data: message.representation) { error in
                    if let error = error {
                        completion(.failure(error))
                        return
                    }
                    completion(.success(Void()))
                }
            }
        }
    }
    
    //MARK: - sendMessage
    func sendMessage(chat: MChat, message: MMessage, completion: @escaping(Result<Void, Error>) -> ()) {
        
        let friendRef = userRef.document(chat.friendId).collection(K.activeChats).document(currentUser.id)
        let friendMessageRef = friendRef.collection(K.messages)
        let myMessagesRef = userRef.document(currentUser.id).collection(K.activeChats).document(chat.friendId).collection(K.messages)
        //      let myMessagesRef1 = userRef.document([currentUser.id, K.activeChats, chat.friendId, K.messages].joined(separator: "/"))
        
        let chatForFriend = chat.mirrorChatFor(currentUser: currentUser)
        
        friendRef.setData(chatForFriend.representation) { error in
            if let error = error { completion(.failure(error)) }
            print(message.representation)
            
            friendMessageRef.addDocument(data: message.representation) { error in
                if let error = error { completion(.failure(error)) }
                
                myMessagesRef.addDocument(data: message.representation) { error in
                    if let error = error { completion(.failure(error)) }
                    completion(.success(Void()))
                }
            }
        }
    }
}
