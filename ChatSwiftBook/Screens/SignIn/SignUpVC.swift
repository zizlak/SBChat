//
//  SignUpVC.swift
//  ChatSwiftBook
//
//  Created by Aleksandr Kurdiukov on 24.06.21.
//

import UIKit

class SignUpVC: UIViewController {
    
    //MARK: - Interface
    
    //Labels
    let welcomeLabel = UILabel(text: "Good to see you!", font: .avenir26)
    
    let emailLabel = UILabel(text: "Email")
    let passwordLabel = UILabel(text: "Password")
    let confirmLabel = UILabel(text: "Confirm password")
    let alreadyOBLabel = UILabel(text: "Already onboard")
    
    //TextFields
    let emailTF = OneLineTF()
    let passwordTF = OneLineTF()
    let confirmTF = OneLineTF()
    
    
    //Buttons
    let signUpButton = UIButton(title: "Sign Up", titleColor: .white, backgroundColor: .buttonDark, cornerRadius: 4)
    let loginButton = UIButton(title: "Login", titleColor: .buttonRed, backgroundColor: .clear)
    
    
    //MARK: - Properties
    weak var delegate: AuthVCDelegate?
    
    //MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        setupConstraints()
        setupSignupButton()
        setupLoginButton()
    }
    
    //MARK: - Methods
    
    private func setupSignupButton() {
        signUpButton.addTarget(self, action: #selector(signupAction), for: .touchUpInside)
    }
    
    @objc private func signupAction() {
        AuthService.shared.authWith(email: emailTF.text, password: passwordTF.text, confirm: confirmTF.text) { [weak self] result in
            guard let self = self else { return }
            switch result {
            
            case .success(let user):
                self.showAlert(title: "Success", message: user.email!) {
                    let vc = SetupProfileVC(user: user)
                    self.present(vc, animated: true)
                }

            case .failure(let error):
                self.showAlert(title: "Error", message: error.localizedDescription)
            }
        }
    }
    
    private func setupLoginButton() {
        loginButton.addTarget(self, action: #selector(loginAction), for: .touchUpInside)
    }
    
    @objc func loginAction() {
        dismiss(animated: true) {
            self.delegate?.toLoginVC()
        }
    }
}



//MARK: - Extensions
extension SignUpVC {
    
    private func setupConstraints() {
        
        let emailStackView = UIStackView(arrangedSubViews: [emailLabel, emailTF], axis: .vertical, spacing: 0)
        let passwordStackView = UIStackView(arrangedSubViews: [passwordLabel, passwordTF], axis: .vertical, spacing: 0)
        let confirmStackView = UIStackView(arrangedSubViews: [confirmLabel, confirmTF], axis: .vertical, spacing: 0)
        
        signUpButton.heightAnchor.constraint(equalToConstant: 60).isActive = true
        
        let stackView = UIStackView(arrangedSubViews: [
                                        emailStackView,
                                        passwordStackView,
                                        confirmStackView,
                                        signUpButton],
                                    axis: .vertical,
                                    spacing: 40)
        
        let bottomStackView = UIStackView(arrangedSubViews: [alreadyOBLabel, loginButton], axis: .horizontal, spacing: 10)
        bottomStackView.alignment = .firstBaseline
        loginButton.contentHorizontalAlignment = .leading
        
        welcomeLabel.translatesAutoresizingMaskIntoConstraints = false
        stackView.translatesAutoresizingMaskIntoConstraints = false
        bottomStackView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addViews(welcomeLabel, stackView, bottomStackView)
        
        NSLayoutConstraint.activate([
            
            //Welcome Label
            welcomeLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 160),
            welcomeLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            //StackView
            stackView.topAnchor.constraint(equalTo: welcomeLabel.bottomAnchor, constant: 60),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            //login
            bottomStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            bottomStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            bottomStackView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -60)
            
        ])
    }
}





//MARK: - PreviewProvider
import SwiftUI

struct SignUpVCProvider: PreviewProvider {
    
    static var previews: some View {
        ContainerView().edgesIgnoringSafeArea(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
    }
    
    struct ContainerView: UIViewControllerRepresentable {
        let vc = SignUpVC()
        
        func makeUIViewController(context: Context) -> SignUpVC {
            return vc
        }
        
        func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        }
    }
}
