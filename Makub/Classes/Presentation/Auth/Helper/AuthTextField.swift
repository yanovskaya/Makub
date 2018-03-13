//
//  AuthTextField.swift
//  Makub
//
//  Created by Елена Яновская on 13.03.2018.
//  Copyright © 2018 Elena Yanovskaya. All rights reserved.
//

import UIKit

final class AuthTextField: UITextField {
    
    // MARK: - Constants
    
    private enum Constants {
        static let usernamePlaceholder = NSLocalizedString("username_placeholder", comment: "")
        static let passwordPlaceholder = NSLocalizedString("password_placeholder", comment: "")
    }

    // MARK: - Initialization
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        clearBachground()
        
        configureShadow()
        configureText()
        configureBorder()
    }

    
    // MARK: - Private Methods
    
    private func configureBorder() {
        layer.opacity = 0.6
        layer.borderWidth = 1
        layer.borderColor = PaleteColors.borderAuthTextField.cgColor
        layer.cornerRadius = frame.height / 2
    }
    
    private func configureShadow() {
        layer.shadowOpacity = 0.1
        layer.shadowOffset = CGSize(width: 0, height: 3)
        layer.shadowColor = UIColor.gray.cgColor
        layer.shadowRadius = 6
    }
    
    private func configureText() {
        font = UIFont.customFont(.robotoLightFont(size: 16))
        textColor = UIColor.white
        
        guard let text = text else { return }
        let textShadow = NSShadow()
        textShadow.shadowBlurRadius = 6
        textShadow.shadowOffset = CGSize(width: 0, height: 3)
        textShadow.shadowColor = UIColor.gray
        
        let textAttribute = [NSAttributedStringKey.shadow: textShadow]
        let shadowString = NSAttributedString(string: text, attributes: textAttribute)
        attributedText = shadowString
    }
    
    private func clearBachground() {
        backgroundColor = UIColor.clear
    }
    
}
