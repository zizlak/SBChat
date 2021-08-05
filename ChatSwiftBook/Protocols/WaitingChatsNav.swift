//
//  WaitingChatsNav.swift
//  ChatSwiftBook
//
//  Created by Aleksandr Kurdiukov on 04.08.21.
//

import Foundation

protocol WaitingChatsNav: AnyObject{
    func removeWaiting(chat: MChat)
    func chatToActive(chat: MChat)
}
