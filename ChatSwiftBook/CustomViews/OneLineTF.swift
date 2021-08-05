//
//  OneLineTF.swift
//  ChatSwiftBook
//
//  Created by Aleksandr Kurdiukov on 24.06.21.
//

import UIKit

class OneLineTF: UITextField {
    
    //MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: .zero)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    //MARK: - Methods
    private func configure() {
        self.font = .avenir20
        self.borderStyle = .none
        self.textColor = .black
        self.translatesAutoresizingMaskIntoConstraints = false
        
        let bottomView = UIView()
        bottomView.backgroundColor = .tfLight
        self.addSubview(bottomView)
        
        bottomView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            bottomView.bottomAnchor.constraint(equalTo: bottomAnchor),
            bottomView.leadingAnchor.constraint(equalTo: leadingAnchor),
            bottomView.trailingAnchor.constraint(equalTo: trailingAnchor),
            bottomView.heightAnchor.constraint(equalToConstant: 1)
        ])
    }
}
