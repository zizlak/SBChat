//
//  ChatRequestVC.swift
//  ChatSwiftBook
//
//  Created by Aleksandr Kurdiukov on 24.07.21.
//

import UIKit
import SDWebImage

class ChatRequestVC: UIViewController {
    
    //MARK: - Interface
    
    let containerView = UIView()
    let imageView = UIImageView(image: #imageLiteral(resourceName: "human8"), contentMode: .scaleAspectFill)
    let nameLabel = UILabel(text: "Peter Ben", font: .systemFont(ofSize: 20, weight: .light))
    let aboutLabel = UILabel(text: "You have the opportunity to start a new chat", font: .systemFont(ofSize: 16, weight: .light))
    let acceptButton = UIButton(title: "ACCEPT", titleColor: .white, backgroundColor: .black, font: .laoSangmamMN20, isShadow: false, cornerRadius: 10)
    let denyButton = UIButton(title: "DENY", titleColor: #colorLiteral(red: 0.8352941176, green: 0.2, blue: 0.2, alpha: 1), backgroundColor: .mainWhite, font: .laoSangmamMN20, isShadow: false, cornerRadius: 10)
    var buttonStackView: UIStackView!
    
    //MARK: - Properties
    
    private let chat: MChat
    weak var delegate: WaitingChatsNav?
    
    //MARK: - LifeCycle Methods
    
    init(chat: MChat) {
        self.chat = chat
        
        nameLabel.text = chat.friendUsername
        imageView.sd_setImage(with: URL(string: chat.friendAvatarStringURL))
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .mainWhite
        
        setupViews()
        setupConstraints()
        setupButtons()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        acceptButton.applyGradients(cornerRadius: 10)
    }
    
    
    //MARK: - Methods

    private func setupViews() {
        
        buttonStackView = UIStackView(arrangedSubViews: [acceptButton, denyButton], axis: .horizontal, spacing: 7)
        buttonStackView.distribution = .fillEqually
        
        for v in [containerView, imageView, nameLabel, aboutLabel, buttonStackView] {
            v?.translatesAutoresizingMaskIntoConstraints = false
        }
        
        denyButton.layer.borderWidth = 1.2
        denyButton.layer.borderColor = #colorLiteral(red: 0.8352941176, green: 0.2, blue: 0.2, alpha: 1)
        
        aboutLabel.numberOfLines = 0
        
        containerView.backgroundColor = .mainWhite
        containerView.layer.cornerRadius = 30
        
        view.addViews(imageView, containerView)
        containerView.addViews(aboutLabel, nameLabel, buttonStackView)

    }
   
    
    private func setupConstraints() {
        for v in [containerView, imageView] {
            NSLayoutConstraint.activate([
                v.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                v.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            ])
        }

        
        for v in [nameLabel, aboutLabel, buttonStackView!] {
            NSLayoutConstraint.activate([
                v.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 24),
                v.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -24)
            ])
        }
        
        NSLayoutConstraint.activate([
            containerView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            containerView.heightAnchor.constraint(equalToConstant: 206),
            
            imageView.topAnchor.constraint(equalTo: view.topAnchor),
            imageView.bottomAnchor.constraint(equalTo: containerView.topAnchor, constant: 30),
            
            nameLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 35),
            
            aboutLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 8),
            
            buttonStackView.topAnchor.constraint(equalTo: aboutLabel.bottomAnchor, constant: 24),
            buttonStackView.heightAnchor.constraint(equalToConstant: 56)
        ])
    }
    
    
    private func setupButtons() {
        denyButton.addTarget(self, action: #selector(deny), for: .touchUpInside)
        acceptButton.addTarget(self, action: #selector(accept), for: .touchUpInside)
    }
    
    @objc func deny() {
        dismiss(animated: true) {
            self.delegate?.removeWaiting(chat: self.chat)
        }
    }
    
    @objc func accept() {
        dismiss(animated: true) {
            self.delegate?.chatToActive(chat: self.chat)
        }
    }
}




//MARK: - Extensions


//MARK: - PreviewProvider
import SwiftUI

struct ChatRequestVCProvider: PreviewProvider {
    
    static var previews: some View {
        ContainerView().edgesIgnoringSafeArea(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
    }
    
    struct ContainerView: UIViewControllerRepresentable {
        
        func makeUIViewController(context: Context) -> some UIViewController {
            return ChatRequestVC(chat: MChat(friendID: "String", friendUsername: "String", friendAvatarStringURL: "String", lastMessageContent: "String"))
        }
        
        func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        }
    }
}
