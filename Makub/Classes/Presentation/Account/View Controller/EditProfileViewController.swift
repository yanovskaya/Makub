//
//  EditProfileViewController.swift
//  Makub
//
//  Created by Елена Яновская on 25.04.2018.
//  Copyright © 2018 Elena Yanovskaya. All rights reserved.
//

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
    }
    
    // MARK: - IBOutlets
    
    @IBOutlet private var profileImageView: UIImageView!
    @IBOutlet private var nameTextField: UITextField!
    @IBOutlet private var surnameTextField: UITextField!
    @IBOutlet private var changePasswordLabel: UILabel!
    @IBOutlet private var newPasswordTextField: UITextField!
    @IBOutlet private var newPasswordLabel: UILabel!
    @IBOutlet private var newPasswordRepeatLabel: UILabel!
    @IBOutlet private var newPasswordRepeatTextField: UITextField!
    
    @IBOutlet private var settingLineViews: [UIView]!
    @IBOutlet private var userLineViews: [UIView]!
    
    @IBOutlet private var navBackgroundView: UIView!
    @IBOutlet private var navigationBar: UINavigationBar!
    
    @IBOutlet private var doneButtonItem: UIBarButtonItem!
    @IBOutlet private var cancelButtonItem: UIBarButtonItem!
    
    // MARK: - ViewController lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = PaletteColors.blueBackground
        for lineView in userLineViews {
            lineView.backgroundColor = PaletteColors.lineGray
        }
        for lineView in settingLineViews {
            lineView.backgroundColor = PaletteColors.lineGray
        }
        changePasswordLabel.text = Constants.changePasswordLabel
        newPasswordLabel.text = Constants.newPasswordLabel
        newPasswordRepeatLabel.text = Constants.newPasswordRepeatLabel
        configureNavigationBar()
        configureFont()
        configureColor()
        hideKeyboardWhenTappedAround()
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
}
