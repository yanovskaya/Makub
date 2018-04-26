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
        static let backImage = "arrow_left"
        static let changeInfoLabel = "Изменение данных"
        static let loginLabel = "Логин"
        static let emailLabel = "Email"
        static let changePasswordLabel = "Изменение пароля"
        static let newPasswordLabel = "Новый"
        static let newPasswordRepeatLabel = "Подтвердить"
    }
    
    // MARK: - IBOutlets
    
    @IBOutlet private var profileImageView: UIImageView!
    @IBOutlet private var nameTextField: UITextField!
    @IBOutlet private var surnameTextField: UITextField!
    @IBOutlet private var changeInfoLabel: UILabel!
    @IBOutlet private var loginLabel: UILabel!
    @IBOutlet private var emailLabel: UILabel!
    @IBOutlet private var loginTextField: UITextField!
    @IBOutlet private var emailTextField: UITextField!
    @IBOutlet private var changePasswordLabel: UILabel!
    @IBOutlet private var newPasswordTextField: UITextField!
    @IBOutlet private var newPasswordLabel: UILabel!
    @IBOutlet private var newPasswordRepeatLabel: UILabel!
    @IBOutlet private var newPasswordRepeatTextField: UITextField!
    
    @IBOutlet private var settingLineViews: [UIView]!
    @IBOutlet private var userLineViews: [UIView]!
    
    // MARK: - ViewController lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = PaletteColors.blueBackground
        for lineView in userLineViews {
            lineView.backgroundColor = PaletteColors.lineGray
        }
        for lineView in settingLineViews {
            lineView.backgroundColor = PaletteColors.lineDarkGray
        }
    }


}
