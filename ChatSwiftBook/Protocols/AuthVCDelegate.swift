//
//  AuthVCDelegate.swift
//  ChatSwiftBook
//
//  Created by Aleksandr Kurdiukov on 27.07.21.
//

import Foundation

protocol AuthVCDelegate: AnyObject {
    func toLoginVC()
    func toSignupVC()
}
