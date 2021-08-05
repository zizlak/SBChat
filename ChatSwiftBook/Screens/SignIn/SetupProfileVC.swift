//
//  SetupProfileVC.swift
//  ChatSwiftBook
//
//  Created by Aleksandr Kurdiukov on 29.06.21.
//

import UIKit
import FirebaseAuth
import SDWebImage

class SetupProfileVC: UIViewController {
    
    //MARK: - Interface
    
    //Image
    let fullImageView = AddPhotoView()
    
    //Labels
    let welcomeLabel = UILabel(text: "Set up profile!", font: .avenir26)
    
    let fullNameLabel = UILabel(text: "Full Name")
    let aboutMeLabel = UILabel(text: "About me")
    let sexLabel = UILabel(text: "Sex")
    
    //TextFields
    let fullNameTF = OneLineTF()
    let aboutMeTF = OneLineTF()
    
    //segmentControl
    let segmentControl = UISegmentedControl(first: "male", second: "female")
    
    //Button
    let goToChatsButton = UIButton(title: "Go to chats!", titleColor: .white, backgroundColor: .buttonDark, cornerRadius: 4)
    
    //MARK: - Properties
    
    private let currentUser: User
    
    
    //MARK: - LifeCycle Methods
    
    
    init(user: User) {
        self.currentUser = user
        super.init(nibName: nil, bundle: nil)
        fillFields()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        configureElements()
    }
    
    
    //MARK: - Methods
    
    private func fillFields() {
        if let name = currentUser.displayName {
            fullNameTF.text = name
        }
        
        if let photoURL = currentUser.photoURL {
            fullImageView.circleImageView.sd_setImage(with: photoURL)
        }
    }

    
    
    private func configureElements() {
        let fullNameStackView = UIStackView(arrangedSubViews: [fullNameLabel, fullNameTF], axis: .vertical)
        let aboutMeStackView = UIStackView(arrangedSubViews: [aboutMeLabel, aboutMeTF], axis: .vertical)
        let sexStackView = UIStackView(arrangedSubViews: [sexLabel, segmentControl], axis: .vertical, spacing: 12)
        
        goToChatsButton.heightAnchor.constraint(equalToConstant: 60).isActive = true
        
        let stackView = UIStackView(arrangedSubViews: [fullNameStackView, aboutMeStackView, sexStackView, goToChatsButton], axis: .vertical, spacing: 40)
        
        
        welcomeLabel.translatesAutoresizingMaskIntoConstraints = false
        fullImageView.translatesAutoresizingMaskIntoConstraints = false
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addViews(welcomeLabel, fullImageView, stackView)
        
        NSLayoutConstraint.activate([
            welcomeLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 160),
            welcomeLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            fullImageView.topAnchor.constraint(equalTo: welcomeLabel.bottomAnchor,constant: 40),
            fullImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            stackView.topAnchor.constraint(equalTo: fullImageView.bottomAnchor, constant: 40),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        
        fullImageView.plusButton.addTarget(self, action: #selector(addAvatar), for: .touchUpInside)
        goToChatsButton.addTarget(self, action: #selector(goToChats), for: .touchUpInside)
    }
    
    @objc private func addAvatar() {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .photoLibrary
        self.present(picker, animated: true)
    }
    
    @objc private func goToChats() {
        FireStoreService.shared.saveProfile(
            id: currentUser.uid,
            userName: fullNameTF.text,
            email: currentUser.email ?? "",
            avatarImage: fullImageView.circleImageView.image,
            description: aboutMeTF.text,
            gender: segmentControl.titleForSegment(at: segmentControl.selectedSegmentIndex)) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            
            case .success(let muser):
                self.showAlert(title: "Success", message: "User \(muser.username) created") {
                    let vc = MainTabBarController(user: muser)
                    vc.modalPresentationStyle = .fullScreen
                    self.present(vc, animated: true)
                }
            case .failure(let error):
                print(#function)
                self.showAlert(title: "Error", message: error.localizedDescription)
            }
        }
    }
}




//MARK: - Extensions
//MARK: - UIImagePicker


extension SetupProfileVC: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else { return }
        picker.dismiss(animated: true) { [weak self] in
            guard let self = self else { return }
            self.fullImageView.circleImageView.image = image
        }
    }
}





//MARK: - PreviewProvider
import SwiftUI

struct SetupProfileVCProvider: PreviewProvider {
    
    static var previews: some View {
        ContainerView().edgesIgnoringSafeArea(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
    }
    
    struct ContainerView: UIViewControllerRepresentable {
        let vc = SetupProfileVC(user: Auth.auth().currentUser!)
        
        func makeUIViewController(context: Context) -> SetupProfileVC {
            return vc
        }
        
        func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        }
    }
}
