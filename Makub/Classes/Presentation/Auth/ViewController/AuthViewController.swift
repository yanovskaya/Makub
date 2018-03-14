//
//  ViewController.swift
//  Makub
//
//  Created by Елена Яновская on 11.03.2018.
//  Copyright © 2018 Elena Yanovskaya. All rights reserved.
//

import UIKit

final class AuthViewController: UIViewController {
    
    // MARK: - Constants
    
    private enum Constants {
        static let authBackgroundImage = "auth_background"
        static let logoImage = "logo"
        static let userImage = "user"
        static let lockImage = "lock"
        
        static let usernamePlaceholder = "Имя пользователя"
        static let passwordPlaceholder = "Пароль"
        static let passButton = "Войти"
    }
    
    // MARK: - IBOutlets
    
    @IBOutlet private var logoImageView: UIImageView!
    @IBOutlet private var backgoundImageView: UIImageView!
    
    @IBOutlet private var usernameTextField: AuthTextField!
    @IBOutlet private var passwordTextField: AuthTextField!
    
    @IBOutlet private var passButton: UIButton!
    
    // MARK: - ViewController lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyboardWhenTappedAround()
        usernameTextField.delegate = self
        passwordTextField.delegate = self
        
        configureBackgroundImage()
        configureImageView()
        configureTextFields()
        configurePassButton()
        enablePassButton()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        print(usernameTextField.frame.width)
    }
    // MARK: - Private Methods
    
    private func configureBackgroundImage() {
        backgoundImageView.image = UIImage(named: Constants.authBackgroundImage)
        backgoundImageView.contentMode = .scaleAspectFill
    }
    
    private func configureImageView() {
        logoImageView.contentMode = .scaleAspectFit
        logoImageView.tintColor = UIColor.white
        logoImageView.image = UIImage(named: Constants.logoImage)?.withRenderingMode(.alwaysTemplate)
        logoImageView.layer.opacity = 0.95
        
        logoImageView.layer.shadowOpacity = 0.16
        logoImageView.layer.shadowOffset = CGSize(width: 0, height: 3)
        logoImageView.layer.shadowColor = UIColor.gray.cgColor
        logoImageView.layer.shadowRadius = 6
    }
    
    private func configureTextFields() {
        usernameTextField.placeholder = Constants.usernamePlaceholder
        passwordTextField.placeholder = Constants.passwordPlaceholder
        
        usernameTextField.attributePlaceholder()
        passwordTextField.attributePlaceholder()
        
        usernameTextField.addImage(Constants.userImage)
        passwordTextField.addImage(Constants.lockImage)
        
        fixTextFieldWidth()
    }
    
    private func configurePassButton() {
        passButton.backgroundColor = PaleteColors.passButtonBackground
        passButton.tintColor = UIColor.white
        
        passButton.layer.shadowOpacity = 0.16
        passButton.layer.shadowOffset = CGSize(width: 0, height: 3)
        passButton.layer.shadowColor = UIColor.gray.cgColor
        passButton.layer.shadowRadius = 6
        passButton.layer.cornerRadius = passButton.frame.height / 2
        passButton.layer.opacity = 0.9
        
        passButton.titleLabel?.font = UIFont.customFont(.robotoBoldFont(size: 18))
        passButton.setTitle(Constants.passButton, for: .normal)
    }
    
    private func enablePassButton() {
        passButton.isEnabled = false
        usernameTextField.addTarget(self, action: #selector(editingChanged), for: .editingChanged)
        passwordTextField.addTarget(self, action: #selector(editingChanged), for: .editingChanged)
    }
    
    private func fixTextFieldWidth() {
        let width = usernameTextField.frame.width
        usernameTextField.widthAnchor.constraint(equalToConstant: width).isActive = true
    }
    
}

// MARK: - UITextFieldDelegate

extension AuthViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        if textField == usernameTextField {
            passwordTextField.becomeFirstResponder()
        }
        return true
    }
    
    @objc private func editingChanged(_ textField: UITextField) {
        guard
            let username = usernameTextField.text, username.count > 2,
            let password = passwordTextField.text, password.count > 2
            else {
                passButton.isEnabled = false
                return
        }
        passButton.isEnabled = true
    }
}
