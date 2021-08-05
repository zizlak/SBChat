//
//  SelfConfiguringCell.swift
//  ChatSwiftBook
//
//  Created by Aleksandr Kurdiukov on 03.07.21.
//

import Foundation

protocol SelfConfiguringCell {
    
    static var reuseID: String { get }
    func configureWith<U: Hashable>(value: U)
}

