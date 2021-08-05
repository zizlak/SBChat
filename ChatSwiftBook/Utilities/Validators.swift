//
//  Validators.swift
//  ChatSwiftBook
//
//  Created by Aleksandr Kurdiukov on 27.07.21.
//

import Foundation

class Validators {
    
    static func isFilled(email: String?, password: String?, confirm: String?) -> Bool {
        guard let email = email, !email.isEmpty,
              let password = password, !password.isEmpty,
              let confirm = confirm, !confirm.isEmpty else { return false }
        
        return true
    }
    
    static func isFilled(email: String?, password: String?) -> Bool {
        guard let email = email, !email.isEmpty,
              let password = password, !password.isEmpty else { return false }
        
        return true
    }
    
    static func isFilled(userName: String?, description: String?, gender: String?) -> Bool {
        guard let userName = userName, !userName.isEmpty,
              let gender = gender, !gender.isEmpty,
              let description = description, !description.isEmpty else { return false }
        
        return true
    }
    
    static func isSimpleEmail(_ email: String?) -> Bool {
        guard let email = email else { return false }
        let emailRegEx = "^.+@.+\\..{2,}$"
        return check(text: email, regEx: emailRegEx)
    }
    
    static private func check(text: String, regEx: String) -> Bool {
        let predicate = NSPredicate(format: "SELF MATCHES %@", regEx)
        return predicate.evaluate(with: text)
    }
}
