//
//  ActiveChatCell.swift
//  ChatSwiftBook
//
//  Created by Aleksandr Kurdiukov on 03.07.21.
//

import UIKit

class ActiveChatCell: UICollectionViewCell, SelfConfiguringCell {
    

    //MARK: - Interface
    
    let friendImageView = UIImageView()
    let friendNameLabel = UILabel(text: "UserName", font: .laoSangmamMN20)
    let lastMessageLabel = UILabel(text: "How R U?", font: .laoSangmamMN18)
    
    let gradientView = GradientView(from: .topTrailing, to: .bottomLeading, start: #colorLiteral(red: 0.7882352941, green: 0.631372549, blue: 0.9411764706, alpha: 1), end: #colorLiteral(red: 0.4784313725, green: 0.6980392157, blue: 0.9215686275, alpha: 1))
    
    
    //MARK: - Properties
    
    static var reuseID: String = String(describing: ActiveChatCell.self)
    
    //MARK: - LifeCycle Methods
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupCell()
        setupConstraints()
        friendImageView.contentMode = .scaleAspectFill
        friendImageView.clipsToBounds = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    //MARK: - Methods
    
    func configureWith<U>(value: U) where U : Hashable {
        guard let chat: MChat = value as? MChat else { return }
        friendImageView.sd_setImage(with: URL(string: chat.friendAvatarStringURL))
        friendNameLabel.text = chat.friendUsername
        lastMessageLabel.text = chat.lastMessageContent
    }
    
    private func setupCell() {
        backgroundColor = .white
        layer.cornerRadius = 8
        clipsToBounds = true
    }
    
    
    private func setupConstraints() {
        self.addViews(friendImageView, friendNameLabel, lastMessageLabel, gradientView)
        
        friendImageView.translatesAutoresizingMaskIntoConstraints = false
        friendImageView.backgroundColor = .orange
        
        friendNameLabel.translatesAutoresizingMaskIntoConstraints = false
        lastMessageLabel.translatesAutoresizingMaskIntoConstraints = false
        
        gradientView.translatesAutoresizingMaskIntoConstraints = false
        gradientView.backgroundColor = .purple
        
        NSLayoutConstraint.activate([
        
            friendImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            friendImageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            friendImageView.heightAnchor.constraint(equalToConstant: 78),
            friendImageView.widthAnchor.constraint(equalTo: friendImageView.heightAnchor),
            
            gradientView.centerYAnchor.constraint(equalTo: centerYAnchor),
            gradientView.trailingAnchor.constraint(equalTo: trailingAnchor),
            gradientView.heightAnchor.constraint(equalToConstant: 78),
            gradientView.widthAnchor.constraint(equalToConstant: 8),
            
            friendNameLabel.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            friendNameLabel.leadingAnchor.constraint(equalTo: friendImageView.trailingAnchor, constant: 8),
            friendNameLabel.trailingAnchor.constraint(equalTo: gradientView.leadingAnchor, constant: -8),
            
            lastMessageLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8),
            lastMessageLabel.leadingAnchor.constraint(equalTo: friendImageView.trailingAnchor, constant: 8),
            lastMessageLabel.trailingAnchor.constraint(equalTo: gradientView.leadingAnchor, constant: -8)
        ])
    }
}






//MARK: - PreviewProvider
import SwiftUI

struct ActiveChatCellProvider: PreviewProvider {
    
    static var previews: some View {
        ContainerView().edgesIgnoringSafeArea(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
    }
    
    struct ContainerView: UIViewControllerRepresentable {
        let vc = MainTabBarController(user: MUser(username: "Stepan", avatarStringURL: "", id: "1", description: "HoHoHo", gender: "male"))
        
        func makeUIViewController(context: Context) ->  MainTabBarController {
            return vc
        }
        
        func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        }
    }
}
