//
//  UserCell.swift
//  ChatSwiftBook
//
//  Created by Aleksandr Kurdiukov on 16.07.21.
//

import UIKit
import SDWebImage

class UserCell: UICollectionViewCell, SelfConfiguringCell {
    
    
    //MARK: - Interface
    
    let userImageView = UIImageView()
    let userNameLabel = UILabel(text: "text", font: .laoSangmamMN20)
    let containerView = UIView()
    
    
    //MARK: - Properties
    
    static var reuseID = String(describing: UserCell.self)
    
    
    //MARK: - LifeCycle Methods
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        setupConstraints()
        
        self.layer.shadowColor = #colorLiteral(red: 0.7411764706, green: 0.7411764706, blue: 0.7411764706, alpha: 1)
        self.layer.shadowRadius = 3
        self.layer.shadowOpacity = 0.5
        self.layer.shadowOffset = CGSize(width: 0, height: 4)
        
        self.layer.cornerRadius = 4
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        containerView.layer.cornerRadius = 4
        containerView.clipsToBounds = true
    }
    
    
    override func prepareForReuse() {
        userImageView.image = nil
    }
    
    
    //MARK: - Methods
    
    func configureWith<U>(value: U) where U : Hashable {
        guard let user = value as? MUser else { return }
        userImageView.image = UIImage(named: user.avatarStringURL)
        userNameLabel.text = user.username
        
        guard let url = URL(string: user.avatarStringURL) else { return }
        userImageView.sd_setImage(with: url)

    }
    
    
    private func setupConstraints() {
        for v in [userImageView, userNameLabel] {
            v.translatesAutoresizingMaskIntoConstraints = false
        }
        
        userImageView.backgroundColor = .systemRed
        
        containerView.pin(to: self)
        containerView.addViews(userNameLabel, userImageView)
        
        NSLayoutConstraint.activate([
            userImageView.topAnchor.constraint(equalTo: containerView.topAnchor),
            userImageView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            userImageView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            userImageView.heightAnchor.constraint(equalTo: containerView.widthAnchor),
            
            userNameLabel.topAnchor.constraint(equalTo: userImageView.bottomAnchor),
            userNameLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 8),
            userNameLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -8),
            userNameLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor)
            
        ])
    }
    
    //MARK: - Extensions
    
    
    //MARK: - PreviewProvider
}
