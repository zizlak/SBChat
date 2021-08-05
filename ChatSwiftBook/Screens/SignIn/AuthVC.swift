//
//  AuthViewController.swift
//  ChatSwiftBook
//
//  Created by Aleksandr Kurdiukov on 23.06.21.
//

import UIKit

class AuthVC: UIViewController {
    
    //MARK: - ImageView
    
    let logoImageView = UIImageView(image: #imageLiteral(resourceName: "Logo"), contentMode: .scaleAspectFit)
    
    
    //MARK: - Labels
    
    let googleLabel = UILabel(text: "Get started with")
    let emailLabel = UILabel(text: "Or sign up with")
    let alreadyOBLabel = UILabel(text: "Already on board")
    
    //MARK: - Buttons
    let emailButton = UIButton(title: "Email", titleColor: .white, backgroundColor: .buttonDark)
    
    let loginButton = UIButton(title: "Login", titleColor: .buttonRed, backgroundColor: .white, isShadow: true)
    
    let googleButton = UIButton(title: "Google", titleColor: .black, backgroundColor: .white, isShadow: true)
    
    //MARK: - Properties
    
    let signupVC = SignUpVC()
    let loginVC = LoginVC()
    
    
    //MARK: - LifeCycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        setupConstraints()
        setupEmailButton()
        setupLoginButton()
        setupGoogleButton()
    }
    
}


//MARK: - Extensions

extension AuthVC {
    
    //MARK: - Methods
    
    private func setupConstraints() {
        
        let googleView = ButtonFormView(label: googleLabel, button: googleButton)
        let emailView = ButtonFormView(label: emailLabel, button: emailButton)
        let loginView = ButtonFormView(label: alreadyOBLabel, button: loginButton)
        
        let stackView = UIStackView(arrangedSubViews: [googleView, emailView, loginView], axis: .vertical, spacing: 40)
        
        
        view.addViews(logoImageView, stackView)
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        logoImageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            
            logoImageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 160),
            logoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            stackView.topAnchor.constraint(equalTo: logoImageView.bottomAnchor, constant: 160),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    
    
    private func setupEmailButton() {
        emailButton.addTarget(self, action: #selector(emailAction), for: .touchUpInside)
    }
    
    @objc private func emailAction() {
        signupVC.delegate = self
        present(signupVC, animated: true)
    }
    
    private func setupLoginButton() {
        loginButton.addTarget(self, action: #selector(loginAction), for: .touchUpInside)
    }
    
    @objc private func loginAction() {
        loginVC.delegate = self
        present(loginVC, animated: true)
    }
    
    private func setupGoogleButton() {
        googleButton.customizeGoogleButton()
        googleButton.addTarget(self, action: #selector(signInGoogle), for: .touchUpInside)
    }
}


extension AuthVC: AuthVCDelegate {
    func toLoginVC() {
        loginAction()
    }
    
    func toSignupVC() {
        emailAction()
    }
}



//MARK: - GoogleSignIn

import Firebase
import GoogleSignIn

extension AuthVC {
    
    @objc private func signInGoogle() {
        
        guard let clientID = FirebaseApp.app()?.options.clientID else { return }
        
        // Create Google Sign In configuration object.
        let config = GIDConfiguration(clientID: clientID)
        
        // Start the sign in flow!
        GIDSignIn.sharedInstance.signIn(with: config, presenting: self) { [unowned self] user, error in
            
            FireStoreService.shared.googleLogin(user: user, error: error) { result in
                switch result {
                
                case .success(let user):
                    self.showAlert(title: "Success", message: "User: " + user.email! + "\nsigned up in") {
                        FireStoreService.shared.getUserData(user: user) { result in
                            switch result {
                            case .success(let muser):
                                let vc = MainTabBarController(user: muser)
                                vc.modalPresentationStyle = .fullScreen
                                self.present(vc, animated: true)
                                
                            case .failure(_):
                                self.present(SetupProfileVC(user: user), animated: true)
                            }
                        }
                    }
                case .failure(let error):
                    self.showAlert(title: ChatError.smthWentWrong, message: error.localizedDescription)
                }
            }
        }
    }
}




//MARK: - PreviewProvider

import SwiftUI

struct AuthViewControllerProvider: PreviewProvider {
    
    static var previews: some View {
        ContainerView().edgesIgnoringSafeArea(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
    }
    
    struct ContainerView: UIViewControllerRepresentable {
        let vc = AuthVC()
        
        func makeUIViewController(context: Context) -> AuthVC {
            return vc
        }
        
        func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        }
    }
}
