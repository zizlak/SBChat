//
//  AddPhotoView.swift
//  ChatSwiftBook
//
//  Created by Aleksandr Kurdiukov on 29.06.21.
//

import UIKit

class AddPhotoView: UIView {
    
    //MARK: - Interface
    
    var circleImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = #imageLiteral(resourceName: "avatar-4")
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.borderColor = UIColor.black.cgColor
        imageView.layer.borderWidth = 1
        
        return imageView
    }()
    
    let plusButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(#imageLiteral(resourceName: "plus"), for: .normal)
        button.tintColor = .buttonDark
        
        return button
    }()
    
    //MARK: - Properties
    
    let padding: CGFloat = 10
    
    
    //MARK: - LifeCycle Methods
    
    override init(frame: CGRect){
        super.init(frame: frame)
        
        addViews(circleImageView, plusButton)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        circleImageView.layer.masksToBounds = true
        circleImageView.layer.cornerRadius = circleImageView.frame.width / 2
    }
    
    
    //MARK: - Methods
    
    private func configure() {
        NSLayoutConstraint.activate([
        
            circleImageView.topAnchor.constraint(equalTo: topAnchor),
            circleImageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            circleImageView.widthAnchor.constraint(equalToConstant: 100),
            circleImageView.heightAnchor.constraint(equalTo: circleImageView.widthAnchor),
            circleImageView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            plusButton.leadingAnchor.constraint(equalTo: circleImageView.trailingAnchor, constant: 16),
            plusButton.centerYAnchor.constraint(equalTo: centerYAnchor),
            plusButton.widthAnchor.constraint(equalToConstant: 30),
            plusButton.heightAnchor.constraint(equalTo: plusButton.widthAnchor),
            plusButton.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }
    
}

