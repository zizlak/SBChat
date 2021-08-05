//
//  UISegmentControl+Ext.swift
//  ChatSwiftBook
//
//  Created by Aleksandr Kurdiukov on 29.06.21.
//

import UIKit

extension UISegmentedControl {
    
    convenience init(first: String, second: String) {
        self.init(items: [first, second])
        self.selectedSegmentIndex = 0
    }
}
