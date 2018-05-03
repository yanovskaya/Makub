//
//  RecoverViewController.swift
//  Makub
//
//  Created by Елена Яновская on 17.03.2018.
//  Copyright © 2018 Elena Yanovskaya. All rights reserved.
//

import PKHUD
import UIKit

final class RecoverViewController: UIViewController {
    
    // MARK: - Constants
    
    private enum Constants {
        static let backButtonImage = "arrow_left"
        static let manImage = "sad_man"
        static let mailImage = "mail"
        static let letterImage = "letter"
        
        static let helpTitleLabel = "Не можете войти?"
        static let helpDescriptionLabel = "Мы отправим тебе письмо на указанную почту с инструкциями для восстановленения доступа."
        static let supportLabel = "Поддержка МАКУБ"
        static let emailPlaceholder = "mitchelle53@example.com"
        static let recoverButton = "Отправить"
        
        static let doneTitleLabel = "Готово!"
        static let doneDescriptionLabel = "Письмо с подробными инструкциями отправлено. Не забудь проверить раздел спам."
        static let repeatButton = "Повторить запрос"
    }
    
    private enum LayoutConstants {
        static let minimumLineHeight: CGFloat = 20
    }
    
    // MARK: - IBOutlets
    
    @IBOutlet private var fakeNavigationView: UIView!
    @IBOutlet private var backButton: UIButton!
    
    @IBOutlet private var imageView: UIImageView!
    
    @IBOutlet private var titleLabel: UILabel!
    @IBOutlet private var descriptionLabel: UILabel!
    @IBOutlet private var supportLabel: UILabel!
    
    @IBOutlet private var emailTextField: AuthTextField!
    @IBOutlet private var recoverButton: AuthPassButton!
    
    // MARK: - Private Properties
    
    private let presentationModel = RecoverPresentationModel()
    
    // MARK: - ViewController lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.setNavigationBarHidden(true, animated: false)
        configureFakeNavigationBar()
        
        bindEvents()
        
        hideKeyboardWhenTappedAround()
        emailTextField.delegate = self
        
        configureImage()
        configureTitleLabel()
        configureDescriptionLabel()
        configureSupportLabel()
        configureRecoverButton()
        configureTextField()
        
        enableRecoverButton()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
    }
    
    // MARK: - Private Methods
    
    private func bindEvents() {
        presentationModel.changeStateHandler = { status in
            switch status {
            case .loading:
                HUD.show(.progress)
            case .rich:
                self.updateContent()
                HUD.show(.success)
                HUD.hide(afterDelay: 0.4)
            case .error (let code):
                switch code {
                case -1009, -1001:
                    HUD.show(.labeledError(title: ErrorDescription.title.rawValue, subtitle: ErrorDescription.network.rawValue))
                case 2:
                    HUD.show(.labeledError(title: ErrorDescription.title.rawValue, subtitle: ErrorDescription.recover.rawValue))
                default:
                    HUD.show(.labeledError(title: ErrorDescription.title.rawValue, subtitle: ErrorDescription.server.rawValue))
                }
                HUD.hide(afterDelay: 1.0)
            }
        }
    }
    
    private func configureImage() {
        imageView.image = UIImage(named: Constants.manImage)
        imageView.tintColor = PaletteColors.darkGray
    }
    
    private func configureTitleLabel() {
        titleLabel.textColor = PaletteColors.darkGray
        titleLabel.font = UIFont.customFont(.robotoBoldFont(size: 16))
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
        descriptionLabel.font = UIFont.customFont(.robotoRegularFont(size: 14))
        descriptionLabel.text = Constants.helpDescriptionLabel
    }
    
    private func configureSupportLabel() {
        supportLabel.textColor = PaletteColors.darkGray.withAlphaComponent(0.6)
        supportLabel.font = UIFont.customFont(.robotoRegularFont(size: 14))
        supportLabel.text = Constants.supportLabel
    }
    
    private func configureRecoverButton() {
        recoverButton.setTitle(Constants.recoverButton, for: .normal)
    }
    
    private func configureTextField() {
        let gray = UIColor.gray
        let darkGray = PaletteColors.darkGray
        
        emailTextField.placeholder = Constants.emailPlaceholder
        emailTextField.attributedPlaceholder = NSAttributedString(string: emailTextField.placeholder!, attributes: [NSAttributedStringKey.foregroundColor: gray])
        
        emailTextField.addImage(Constants.mailImage, color: darkGray, opacity: 0.8)
        emailTextField.textColor = PaletteColors.darkGray
        emailTextField.layer.borderColor = PaletteColors.darkGray.withAlphaComponent(0.6).cgColor
        emailTextField.font = UIFont.customFont(.robotoLightFont(size: 15))
    }
    
    private func configureFakeNavigationBar() {
        let backButtonImage = UIImage(named: Constants.backButtonImage)
        fakeNavigationView.backgroundColor = .clear
        backButton.setImage(backButtonImage, for: .normal)
        backButton.setTitle("", for: .normal)
        backButton.tintColor = PaletteColors.darkGray
        
        navigationController?.interactivePopGestureRecognizer?.delegate = nil
    }
    
    private func enableRecoverButton() {
        recoverButton.isEnabled = false
        emailTextField.addTarget(self, action: #selector(editingChanged), for: .editingChanged)
    }
    
    private func updateContent() {
        titleLabel.text = Constants.doneTitleLabel
        descriptionLabel.text = Constants.doneDescriptionLabel
        recoverButton.setTitle(Constants.repeatButton, for: .normal)
        imageView.image = UIImage(named: Constants.letterImage)
    }
    
    private func isValidEmail(_ testStr: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
        let emailTest = NSPredicate(format: "SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: testStr)
    }
    
    @objc private func editingChanged() {
        guard let email = emailTextField.text, isValidEmail(email)
            else {
                recoverButton.isEnabled = false
                return
        }
        recoverButton.isEnabled = true
    }
    
    // MARK: - IBActions
    
    @IBAction private func backButtonTapped(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction private func recoverButtonTapped(_ sender: Any) {
        guard let email = emailTextField.text?.removeWhitespaces() else { return }
        presentationModel.recoverPassword(email: email)
    }
    
}

// MARK: - UITextFieldDelegate

extension RecoverViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
