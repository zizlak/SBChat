//
//  LoginVC.swift
//  ChatSwiftBook
//
//  Created by Aleksandr Kurdiukov on 25.06.21.
//

import UIKit

class LoginVC: UIViewController {
    
    //MARK: - Interface
    
    //Labels
    let welcomeLabel = UILabel(text: "Welcome back!", font: .avenir26)
    
    let loginWithLabel = UILabel(text: "Login with")
    let orLabel = UILabel(text: "or")
    let emailLabel = UILabel(text: "Email")
    let passwordLabel = UILabel(text: "Password")
    let needAccountLabel = UILabel(text: "Need an account?")
    
    //Buttons
    let googleButton = UIButton(title: "Google", titleColor: .black, backgroundColor: .white, isShadow: true)
    let loginButton = UIButton(title: "Login", titleColor: .white, backgroundColor: .buttonDark, isShadow: false)
    let signUpButton = UIButton(title: "Sign Up", titleColor: .buttonRed, backgroundColor: .clear)
    
    //TextFields
    let emailTF = OneLineTF()
    let passwordTF = OneLineTF()
    
    
    //MARK: - Properties
    weak var delegate: AuthVCDelegate?
    
    
    //MARK: - LifeCycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        setUpConstraints()
        setupLoginButton()
        setupSignupButton()
        setupGoogleButton()
    }
    
    
    //MARK: - Methods
    
    private func setupLoginButton() {
        loginButton.addTarget(self, action: #selector(loginAction), for: .touchUpInside)
    }
    
    @objc private func loginAction() {
        AuthService.shared.loginWith(email: emailTF.text, password: passwordTF.text) { [weak self] result in
            guard let self = self else { return }
            switch result {
            
            case .success(let user):
                self.showAlert(title: "Success", message: "User: " + user.email! + "\nlogged in") {
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
                self.showAlert(title: "Error", message: error.localizedDescription)
            }
        }
    }
    
    private func setupSignupButton() {
        signUpButton.addTarget(self, action: #selector(signupAction), for: .touchUpInside)
    }
    
    @objc private func signupAction() {
        dismiss(animated: true) {
            self.delegate?.toSignupVC()
        }
    }
    
    
    private func setupGoogleButton() {
        googleButton.customizeGoogleButton()
        googleButton.addTarget(self, action: #selector(signInGoogle), for: .touchUpInside)
    }
    
    
    private func setUpConstraints() {
        
        let loginWithView = ButtonFormView(label: loginWithLabel, button: googleButton)
        let emailStackView = UIStackView(arrangedSubViews: [emailLabel, emailTF], axis: .vertical)
        let passwordStackView = UIStackView(arrangedSubViews: [passwordLabel, passwordTF], axis: .vertical)
        
        let bottomStackView = UIStackView(arrangedSubViews: [needAccountLabel, signUpButton], axis: .horizontal, spacing: 10)
        
        let stackView = UIStackView(arrangedSubViews: [
                                        loginWithView, orLabel, emailStackView, passwordStackView, loginButton], axis: .vertical, spacing: 40)
        
        signUpButton.contentHorizontalAlignment = .leading
        bottomStackView.alignment = .firstBaseline
        
        
        view.addViews(welcomeLabel, stackView, bottomStackView)
        
        welcomeLabel.translatesAutoresizingMaskIntoConstraints = false
        stackView.translatesAutoresizingMaskIntoConstraints = false
        bottomStackView.translatesAutoresizingMaskIntoConstraints = false
        
        //Constraints
        
        NSLayoutConstraint.activate([
            
            welcomeLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 160),
            welcomeLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            stackView.topAnchor.constraint(equalTo: welcomeLabel.bottomAnchor,constant: 100),
            stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            
            bottomStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            bottomStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            bottomStackView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -40),
            
            loginButton.heightAnchor.constraint(equalToConstant: 60)
            
        ])
        
    }
    
}
//MARK: - Extensions


//MARK: - GoogleSignIn

import Firebase
import GoogleSignIn

extension LoginVC {
    
    @objc private func signInGoogle() {
        
        guard let clientID = FirebaseApp.app()?.options.clientID else { return }
        
        // Create Google Sign In configuration object.
        let config = GIDConfiguration(clientID: clientID)
        
        // Start the sign in flow!
        GIDSignIn.sharedInstance.signIn(with: config, presenting: self) { [unowned self] user, error in
            
            FireStoreService.shared.googleLogin(user: user, error: error) { result in
                switch result {
                
                case .success(let user):
                    self.showAlert(title: "Success", message: "User: " + user.email! + "\nlogged in") {
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

struct LoginVCProvider: PreviewProvider {
    
    static var previews: some View {
        ContainerView().edgesIgnoringSafeArea(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
    }
    
    struct ContainerView: UIViewControllerRepresentable {
        let vc = LoginVC()
        
        func makeUIViewController(context: Context) -> LoginVC {
            return vc
        }
        
        func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        }
    }
}
