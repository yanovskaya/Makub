//
//  RecoverViewController.swift
//  Makub
//
//  Created by Елена Яновская on 17.03.2018.
//  Copyright © 2018 Elena Yanovskaya. All rights reserved.
//

import UIKit

final class RecoverViewController: UIViewController {
    
    // MARK: - Constants
    
    private enum Constants {
        static let manImage = "sad_man"
        static let mailImage = "mail"
        
        static let helpTitleLabel = "Не можете войти?"
        static let helpDescriptionLabel = "Мы отправим тебе письмо на указанную почту с инструкциями для восстановленения доступа."
        static let emailPlaceholder = "mitchelle53@example.com"
        static let recoverButton = "Отправить"
    }
    
    private enum LayoutConstants {
        static let minimumLineHeight: CGFloat = 20
    }
    
    // MARK: - IBOutlets
    
    @IBOutlet private var manImageView: UIImageView!
    
    @IBOutlet private var titleLabel: UILabel!
    @IBOutlet private var descriptionLabel: UILabel!
    
    @IBOutlet private var emailTextField: AuthTextField!
    @IBOutlet private var recoverButton: AuthPassButton!
    
    // MARK: - ViewController lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.setNavigationBarHidden(false, animated: true)
        navigationController?.navigationBar.topItem?.title = " "
        
        hideKeyboardWhenTappedAround()
        emailTextField.delegate = self
        
        configureImage()
        configureTitleLabel()
        configureDescriptionLabel()
        configureRecoverButton()
        configureTextField()
        
        enableRecoverButton()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
    }
    
    // MARK: - Private Methods
    
    private func configureImage() {
        manImageView.image = UIImage(named: Constants.manImage)
        manImageView.tintColor = PaletteColors.darkGray
    }
    
    private func configureTitleLabel() {
        titleLabel.textColor = PaletteColors.darkGray
        titleLabel.font = UIFont.customFont(.robotoBoldFont(size: 18))
        titleLabel.text = Constants.helpTitleLabel
    }
    
    private func configureDescriptionLabel() {
        let text = Constants.helpDescriptionLabel
        let attributedText = NSMutableAttributedString(string: text)
        let style = NSMutableParagraphStyle()
        style.minimumLineHeight = LayoutConstants.minimumLineHeight
        style.alignment = .center
        attributedText.addAttribute(.paragraphStyle, value: style, range: NSRange(location: 0, length: text.count))
        descriptionLabel.attributedText = attributedText
        descriptionLabel.textColor = PaletteColors.darkGray.withAlphaComponent(0.8)
        descriptionLabel.font = UIFont.customFont(.robotoRegularFont(size: 16))
        descriptionLabel.text = Constants.helpDescriptionLabel
    }
    
    private func configureRecoverButton() {
        recoverButton.setTitle(Constants.recoverButton, for: .normal)
    }
    
    private func configureTextField() {
        let gray = UIColor.gray
        let darkGray = PaletteColors.darkGray
        
        emailTextField.placeholder = Constants.emailPlaceholder
        emailTextField.attributedPlaceholder = NSAttributedString(string: emailTextField.placeholder!, attributes: [NSAttributedStringKey.foregroundColor: gray])
        
        emailTextField.textColor = PaletteColors.darkGray
        emailTextField.addImage(Constants.mailImage, color: darkGray, opacity: 0.8)
        emailTextField.layer.borderColor = PaletteColors.darkGray.withAlphaComponent(0.6).cgColor
    }
    
    private func enableRecoverButton() {
        recoverButton.isEnabled = false
        emailTextField.addTarget(self, action: #selector(editingChanged), for: .editingChanged)
    }
    
    @IBAction func recoverButtonTapped(_ sender: Any) {
        titleLabel.text = "fdddfg"
    }
    
}

// MARK: - UITextFieldDelegate

extension RecoverViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    @objc private func editingChanged(_ textField: UITextField) {
        guard let email = emailTextField.text, email.count > 7,
            email.range(of: "@") != nil, email.range(of: ".") != nil
            else {
                recoverButton.isEnabled = false
                return
        }
        recoverButton.isEnabled = true
    }
}
