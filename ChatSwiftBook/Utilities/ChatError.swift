//
//  AuthError.swift
//  ChatSwiftBook
//
//  Created by Aleksandr Kurdiukov on 27.07.21.
//

import Foundation

enum ChatError {
    static let smthWentWrong = "Something went wrong"
    
    //auth
    case invalideEmail
    case invalidePassword
    case passwordsNotMatch
    case emptyFields
    
    ///user
    case usrDoesntExist
    case imageNotExist
}


extension ChatError: LocalizedError {
    var errorDescription: String? {
        switch self {
        
        //Auth
        case .emptyFields:
            return NSLocalizedString("Text fields are not filled", comment: "")
        case .passwordsNotMatch:
            return NSLocalizedString("Passwords don't match", comment: "")
        case .invalideEmail:
            return NSLocalizedString("Invalide email format", comment: "")
            
        //User
        case .usrDoesntExist:
            return NSLocalizedString("This user doesn't exist in Database", comment: "")
        case .imageNotExist:
            return NSLocalizedString("Please add your avatar", comment: "")
            
        default:
            return ChatError.smthWentWrong
        }
    }
}
