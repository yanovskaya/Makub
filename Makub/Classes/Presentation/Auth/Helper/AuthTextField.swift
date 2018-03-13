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
        layer.shadowColor = PaleteColors.shadowAuthTextField.cgColor
        layer.shadowRadius = 6
    }
    
    private func clearBachground() {
        backgroundColor = UIColor.clear
    }
}
