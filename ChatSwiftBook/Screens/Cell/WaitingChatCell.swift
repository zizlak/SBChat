//
//  WaitingChatCell.swift
//  ChatSwiftBook
//
//  Created by Aleksandr Kurdiukov on 03.07.21.
//

import UIKit
import SDWebImage

class WaitingChatCell: UICollectionViewCell, SelfConfiguringCell {

    
    //MARK: - Interface
    
    let friendImageView = UIImageView()
    
    
    //MARK: - Properties
    
    static var reuseID: String = String(describing: WaitingChatCell.self)
    
    
    //MARK: - LifeCycle Methods
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupCell()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Methods
    
    private func setupCell(){
        layer.cornerRadius = 8
        clipsToBounds = true
    }
    
    
    private func setupConstraints() {
        
        friendImageView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(friendImageView)
        
        NSLayoutConstraint.activate([
            friendImageView.topAnchor.constraint(equalTo: topAnchor),
            friendImageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            friendImageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            friendImageView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    
    func configureWith<U>(value: U) where U : Hashable {
        
        guard let chat: MChat = value as? MChat else { return }
        friendImageView.sd_setImage(with: URL(string: chat.friendAvatarStringURL))
    }
}




//MARK: - PreviewProvider
import SwiftUI

struct WaitingChatCellProvider: PreviewProvider {
    
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
