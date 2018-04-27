//
//  EditProfileViewController.swift
//  Makub
//
//  Created by Елена Яновская on 25.04.2018.
//  Copyright © 2018 Elena Yanovskaya. All rights reserved.
//

import Kingfisher
import UIKit

class EditProfileViewController: UIViewController {
    
    // MARK: - Constants
    
    private enum Constants {
        static let cancelButtonItem = "Отмена"
        static let doneButtonItem = "Готово"
        static let title = "Настройки"
        static let changePasswordLabel = "Изменение пароля"
        static let newPasswordLabel = "Новый"
        static let newPasswordRepeatLabel = "Подтвердить"
        static let userImage = "photo_default"
        
        static let cancel = "Отмена"
        static let removePhoto = "Удалить"
        static let chooseFromLibrary = "Выбрать из библиотеки"
        static let takePhoto = "Сделать фото"
    }
    
    // MARK: - Public Properties
    
    let presentationModel = EditProfilePresentationModel()
    
    // MARK: - Private Property
    
    private let indicator = UserIndicator()
    
    // MARK: - IBOutlets
    
    @IBOutlet private var profileImageView: UIImageView!
    @IBOutlet private var nameTextField: UITextField!
    @IBOutlet private var surnameTextField: UITextField!
    @IBOutlet private var changePasswordLabel: UILabel!
    @IBOutlet private var newPasswordTextField: UITextField!
    @IBOutlet private var newPasswordLabel: UILabel!
    @IBOutlet private var newPasswordRepeatLabel: UILabel!
    @IBOutlet private var newPasswordRepeatTextField: UITextField!
    
    @IBOutlet private var lineViews: [UIView]!
    
    @IBOutlet private var navBackgroundView: UIView!
    @IBOutlet private var navigationBar: UINavigationBar!
    
    @IBOutlet private var doneButtonItem: UIBarButtonItem!
    @IBOutlet private var cancelButtonItem: UIBarButtonItem!
    
    // MARK: - ViewController lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = PaletteColors.blueBackground
        for lineView in lineViews {
            lineView.backgroundColor = PaletteColors.lineGray
        }
        configureNavigationBar()
        configureFont()
        configureColor()
        configureLabels()
        configureImageView()
        configureTextFields()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        profileImageView.clipsToBounds = true
        profileImageView.layer.cornerRadius = profileImageView.frame.width / 2
    }
    
    // MARK: - Private Methods
    
    private func configureNavigationBar() {
        navBackgroundView.backgroundColor = .white
        navigationBar.shadowImage = UIImage(color: UIColor.white)
        navigationBar.topItem?.title = Constants.title
        cancelButtonItem.title = Constants.cancelButtonItem
        doneButtonItem.title = Constants.doneButtonItem
        
        let titleTextAttributes: [NSAttributedStringKey: Any] = [NSAttributedStringKey.foregroundColor: PaletteColors.darkGray,
                                                                 NSAttributedStringKey.font: UIFont.customFont(.robotoMediumFont(size: 17))]
        
        let cancelButtonAttributes = [NSAttributedStringKey.foregroundColor: PaletteColors.blueTint,
                                      NSAttributedStringKey.font: UIFont.customFont(.robotoRegularFont(size: 17))]
        let doneButtonAttributes = [NSAttributedStringKey.foregroundColor: PaletteColors.blueTint,
                                    NSAttributedStringKey.font: UIFont.customFont(.robotoBoldFont(size: 17))]
        navigationBar.titleTextAttributes = titleTextAttributes
        cancelButtonItem.setTitleTextAttributes(cancelButtonAttributes, for: .normal)
        cancelButtonItem.setTitleTextAttributes(cancelButtonAttributes, for: .selected)
        
        doneButtonItem.setTitleTextAttributes(doneButtonAttributes, for: .normal)
        doneButtonItem.setTitleTextAttributes(doneButtonAttributes, for: .selected)
        
        doneButtonItem.setTitleTextAttributes([NSAttributedStringKey.font: UIFont.customFont(.robotoBoldFont(size: 17))], for: .disabled)
        doneButtonItem.isEnabled = false
    }
    
    private func configureFont() {
        nameTextField.font = UIFont.customFont(.robotoRegularFont(size: 16))
        surnameTextField.font = UIFont.customFont(.robotoRegularFont(size: 16))
        newPasswordRepeatTextField.font = UIFont.customFont(.robotoRegularFont(size: 16))
        newPasswordTextField.font = UIFont.customFont(.robotoRegularFont(size: 16))
        
        newPasswordRepeatLabel.font = UIFont.customFont(.robotoRegularFont(size: 16))
        newPasswordLabel.font = UIFont.customFont(.robotoRegularFont(size: 16))
        changePasswordLabel.font = UIFont.customFont(.robotoRegularFont(size: 14))
    }
    
    private func configureColor() {
        nameTextField.backgroundColor = .white
        surnameTextField.backgroundColor = .white
        newPasswordTextField.backgroundColor = .white
        newPasswordRepeatTextField.backgroundColor = .white
        
        nameTextField.textColor = PaletteColors.darkGray
        surnameTextField.textColor = PaletteColors.darkGray
        newPasswordTextField.textColor = PaletteColors.darkGray
        newPasswordRepeatTextField.textColor = PaletteColors.darkGray
        
        newPasswordRepeatLabel.textColor = PaletteColors.darkGray
        newPasswordLabel.textColor = PaletteColors.darkGray
        
        changePasswordLabel.textColor = PaletteColors.textGray
    }
    
    private func configureLabels() {
        changePasswordLabel.text = Constants.changePasswordLabel
        newPasswordLabel.text = Constants.newPasswordLabel
        newPasswordRepeatLabel.text = Constants.newPasswordRepeatLabel
        
        guard let viewModel = presentationModel.userViewModel else { return }
        nameTextField.text = viewModel.name
        surnameTextField.text = viewModel.surname
    }
    
    private func configureImageView() {
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageViewTapped))
        profileImageView.addGestureRecognizer(tapGestureRecognizer)
        guard let viewModel = presentationModel.userViewModel else { return }
        if let photoURL = viewModel.photoURL {
            profileImageView.kf.indicatorType = .custom(indicator: indicator)
            profileImageView.kf.setImage(with: URL(string: photoURL), placeholder: nil, options: nil, completionHandler: { (image, _, _, _) in
                if image == nil {
                    self.profileImageView.image = UIImage(named: Constants.userImage)
                }
            })
        } else {
            self.profileImageView.image = UIImage(named: Constants.userImage)
        }
    }
    
    private func configureTextFields() {
        hideKeyboardWhenTappedAround()
        nameTextField.delegate = self
        surnameTextField.delegate = self
        newPasswordTextField.delegate = self
        newPasswordRepeatTextField.delegate = self
    }
    
    @objc private func imageViewTapped() {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let libraryAction = UIAlertAction(title: Constants.chooseFromLibrary, style: .default) { _ in
            imagePickerController.sourceType = .photoLibrary
            self.present(imagePickerController, animated: true, completion: nil)
        }
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            alertController.addAction(libraryAction)
        }
        let cameraAction = UIAlertAction(title: Constants.takePhoto, style: .default) { _ in
            imagePickerController.sourceType = .camera
            self.present(imagePickerController, animated: true, completion: nil)
        }
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            alertController.addAction(cameraAction)
        }
        let removeAction = UIAlertAction(title: Constants.removePhoto, style: .destructive) { _ in
            self.profileImageView.image = UIImage(named: Constants.userImage)
        }
        if profileImageView.image != UIImage(named: Constants.userImage) {
            alertController.addAction(removeAction)
        }
        let cancelAction = UIAlertAction(title: Constants.cancel, style: .cancel)
        alertController.addAction(cancelAction)
        present(alertController, animated: true, completion: nil)
    }
    
    // MARK: - IBActions
    
    @IBAction private func cancelButtonTapped(_ sender: Any) {
        dismiss(animated: true)
    }
    
}

// MARK: UITextFieldDelegate

extension EditProfileViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        if textField == newPasswordTextField {
            newPasswordRepeatTextField.becomeFirstResponder()
        }
        return true
    }
}

// MARK: UIImagePickerControllerDelegate, UINavigationControllerDelegate

extension EditProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String: Any]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            profileImageView.image = image
        }
        dismiss(animated: true, completion: nil)
    }
}
