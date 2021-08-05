//
//  Label+Ext.swift
//  ChatSwiftBook
//
//  Created by Aleksandr Kurdiukov on 23.06.21.
//

import UIKit

extension UILabel {
    
    convenience init (text: String?, font: UIFont? = .avenir20) {
        self.init()
        
        self.text = text
        self.font = font
        textColor = .black
    }
}
