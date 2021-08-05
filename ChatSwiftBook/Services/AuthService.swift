//
//  AuthService.swift
//  ChatSwiftBook
//
//  Created by Aleksandr Kurdiukov on 26.07.21.
//

import UIKit
import FirebaseAuth

class AuthService {
    
    static let shared = AuthService()
    private init(){}
    
    private let auth = Auth.auth()
    func authWith(email: String?, password: String?, confirm: String?, completion: @escaping(Result<User, Error>) -> Void) {
        guard Validators.isFilled(email: email, password: password, confirm: confirm) else { completion(.failure(ChatError.emptyFields)); return }
        
        guard password?.lowercased() == confirm?.lowercased() else {
            completion(.failure(ChatError.passwordsNotMatch)); return }
        
        guard Validators.isSimpleEmail(email) else {
            completion(.failure(ChatError.invalideEmail)); return }
        
        auth.createUser(withEmail: email!, password: password!) { result, error in
            guard let result = result else { completion(.failure(error!)); return }
            
            completion(.success(result.user))
        }
    }
    
    
    func loginWith(email: String?, password: String?, completion: @escaping(Result<User, Error>) -> Void) {
        
        guard Validators.isFilled(email: email, password: password) else {
            completion(.failure(ChatError.emptyFields)); return }
        
        auth.signIn(withEmail: email!, password: password!) { result, error in
            guard let result = result else { completion(.failure(error!)); return }
            
            completion(.success(result.user))
        }
    }
}
