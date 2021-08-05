//
//  ProfileVC.swift
//  ChatSwiftBook
//
//  Created by Aleksandr Kurdiukov on 23.07.21.
//

import UIKit
import SDWebImage

class ProfileVC: UIViewController {
    
    //MARK: - Interface
    
    let containerView = UIView()
    let imageView = UIImageView(image: #imageLiteral(resourceName: "human1"), contentMode: .scaleAspectFill)
    let nameLabel = UILabel(text: "Peter Ben", font: .systemFont(ofSize: 20, weight: .light))
    let aboutLabel = UILabel(text: "You have the opportunity to chat with the best man in the world", font: .systemFont(ofSize: 16, weight: .light))
    let myTextfield = InsertableTF()
    
    //MARK: - Properties
    
    let user: MUser
    
    //MARK: - LifeCycle Methods
    
    init(user: MUser) {
        self.user = user
        nameLabel.text = user.username
        aboutLabel.text = user.description
        imageView.sd_setImage(with: URL(string: user.avatarStringURL))
        super.init(nibName: nil, bundle: nil)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        setupConstraints()
    }
    
    
    
    
    //MARK: - Methods

    private func setupViews() {
        for v in [containerView, imageView, nameLabel, aboutLabel, myTextfield] {
            v.translatesAutoresizingMaskIntoConstraints = false
        }
        aboutLabel.numberOfLines = 0
        
        containerView.backgroundColor = .mainWhite
        containerView.layer.cornerRadius = 30
        
        view.addViews(imageView, containerView)
        containerView.addViews(aboutLabel, nameLabel, myTextfield)
        
        if let button = myTextfield.rightView as? UIButton {
            button.addTarget(self, action: #selector(sendMessage), for: .touchUpInside)
        }
    }
    
    
    
    @objc func sendMessage() {
        guard let message = myTextfield.text, !message.isEmpty else { return }
        self.dismiss(animated: true) {
            FireStoreService.shared.createWatingChats(message: message, reciever: self.user) { result in
                switch result {
                
                case .success():
                    UIApplication.getTopViewController()?.showAlert(title: "Success", message: "your message for \(self.user.username) was sent")
                case .failure(let error):
                    UIApplication.getTopViewController()?.showAlert(title: "Error", message: error.localizedDescription)
                }
            }
        }
    }
    
    
    
    private func setupConstraints() {
        for v in [containerView, imageView] {
            NSLayoutConstraint.activate([
                v.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                v.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            ])
        }
        
        for v in [nameLabel, aboutLabel, myTextfield] {
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
            
            myTextfield.topAnchor.constraint(equalTo: aboutLabel.bottomAnchor, constant: 8),
            myTextfield.heightAnchor.constraint(equalToConstant: 48)
        ])
        
    }
}







//MARK: - PreviewProvider
import SwiftUI

struct ProfileVCProvider: PreviewProvider {
    
    static var previews: some View {
        ContainerView().edgesIgnoringSafeArea(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
    }
    
    struct ContainerView: UIViewControllerRepresentable {
        
        func makeUIViewController(context: Context) -> some UIViewController {
            return ProfileVC(user: MUser(username: "Vova", avatarStringURL: "", id: "", description: "WWWW", gender: "male"))
        }
        
        func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        }
    }
}
