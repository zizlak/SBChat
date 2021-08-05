//
//  UIScrollView+Ext.swift
//  ChatSwiftBook
//
//  Created by Aleksandr Kurdiukov on 05.08.21.
//

import UIKit

extension UIScrollView {
    
    var isAtBottom: Bool {
        contentOffset.y >= verticalOffsetForBottom
    }
    
    
    var verticalOffsetForBottom: CGFloat {
        contentSize.height + contentInset.bottom - bounds.height
    }
}
