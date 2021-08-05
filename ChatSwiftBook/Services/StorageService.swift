//
//  StorageService.swift
//  ChatSwiftBook
//
//  Created by Aleksandr Kurdiukov on 30.07.21.
//

import Foundation
import FirebaseAuth
import FirebaseStorage


class StorageService {
    
    //MARK: - Singeltone
    static let shared = StorageService()
    private init() {}
    
    private var userAvatarRef: StorageReference {
        let storageRef = Storage.storage().reference()
        let avatarRef = storageRef.child("avatars")
        let userAvatarRef = avatarRef.child(currentUserID)
        return userAvatarRef
    }
    
    //MARK: - Properties
    
    private var chatsRef: StorageReference {
        return Storage.storage().reference().child("chats")
    }
    
    private var currentUserID: String {
        Auth.auth().currentUser!.uid
    }
    
    func upload(photo: UIImage, completion: @escaping(Result<URL, Error>) -> ()) {
        guard let scaledImage = photo.scaledToSafeUploadSize, let imageData = scaledImage.jpegData(compressionQuality: 0.4) else { return }
        
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpeg"
        
        userAvatarRef.putData(imageData, metadata: metadata) { metadata, error in
            guard metadata != nil else {
                print(#function)
                completion(.failure(error!))
                return }
        
        
            self.userAvatarRef.downloadURL { url, error in
            guard let url = url else {
                print(#function)
                completion(.failure(error!))
                return }
            
            completion(.success(url))
            }
        }  
    }
    
    
    func uploadImageMessage(photo: UIImage, to chat: MChat, completion: @escaping(Result<URL, Error>) -> ()) {
        guard let scaledImage = photo.scaledToSafeUploadSize, let imageData = scaledImage.jpegData(compressionQuality: 0.4) else { return }
        
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpeg"
        
        let imageName = [UUID().uuidString, String(Date().timeIntervalSince1970)].joined()
        
        let uid: String = Auth.auth().currentUser!.uid
        let chatName = [chat.friendUsername, uid].joined()
        
        self.chatsRef.child(chatName).child(imageName).putData(imageData, metadata: metadata) { metadata, error in
            guard metadata != nil else {
                print(#function)
                completion(.failure(error!))
                return }
            
            self.chatsRef.child(chatName).child(imageName).downloadURL { url, error in
                guard let url = url else {
                    print(#function)
                    completion(.failure(error!))
                    return }
                
                completion(.success(url))
            }
        }
    }
    
    
    func downloadMessageImage(url: URL, completion: @escaping(Result<UIImage?, Error>) -> ()) {
        let ref = Storage.storage().reference(forURL: url.absoluteString)
        let mb = Int64(1 * 1024 * 1024)
        ref.getData(maxSize: mb) { data, error in
            guard let imageData = data else { completion(.failure(error!)); return }
            completion(.success(UIImage(data: imageData)))
        }
    }
}
