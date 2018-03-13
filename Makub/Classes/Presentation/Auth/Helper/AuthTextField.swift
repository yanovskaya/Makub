//
//  AuthTextField.swift
//  Makub
//
//  Created by Елена Яновская on 13.03.2018.
//  Copyright © 2018 Elena Yanovskaya. All rights reserved.
//

import UIKit

final class AuthTextField: UITextField {

    // MARK: - Initialization
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        clearBachground()
        
        configureShadow()
        configureText()
        configureBorder()
    }
    
    // MARK: - Public Methods
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        let padding = UIEdgeInsets(top: 0, left: frame.height/2, bottom: 0, right: frame.height/2)
        return UIEdgeInsetsInsetRect(bounds, padding)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        let padding = UIEdgeInsets(top: 0, left: frame.height/2, bottom: 0, right: frame.height/2)
        return UIEdgeInsetsInsetRect(bounds, padding)
    }
    
    func attributePlaceholder() {
        guard let placeholder = placeholder else { return }
        let color = UIColor.white
        attributedPlaceholder = NSAttributedString(string: placeholder, attributes: [NSAttributedStringKey.foregroundColor: color])
    }
    
    // MARK: - Private Methods
    
    private func configureBorder() {
        layer.opacity = 0.6
        layer.borderWidth = 1
        layer.borderColor = PaleteColors.borderAuthTextField.cgColor
        layer.cornerRadius = frame.height/2
    }
    
    private func configureShadow() {
        layer.shadowOpacity = 0.16
        layer.shadowOffset = CGSize(width: 0, height: 3)
        layer.shadowColor = UIColor.gray.cgColor
        layer.shadowRadius = 6
    }
    
    private func configureText() {
        font = UIFont.customFont(.robotoLightFont(size: 16))
        textColor = UIColor.white
        textAlignment = .center
    }
    
    private func clearBachground() {
        backgroundColor = UIColor.clear
    }
    
}
