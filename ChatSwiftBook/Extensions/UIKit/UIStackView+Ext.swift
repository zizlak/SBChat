//
//  UIStackView+Ext.swift
//  ChatSwiftBook
//
//  Created by Aleksandr Kurdiukov on 24.06.21.
//

import UIKit

extension UIStackView {
    
    convenience init(arrangedSubViews: [UIView], axis: NSLayoutConstraint.Axis, spacing: CGFloat = 0) {
        self.init(arrangedSubviews: arrangedSubViews)
        
        self.axis = axis
        self.spacing = spacing
    }
}
