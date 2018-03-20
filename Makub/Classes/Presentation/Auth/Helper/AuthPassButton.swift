//
//  AuthPassButton.swift
//  Makub
//
//  Created by Елена Яновская on 19.03.2018.
//  Copyright © 2018 Elena Yanovskaya. All rights reserved.
//

import UIKit

final class AuthPassButton: UIButton {
    
    // MARK: - UIView lifecycle

    override func awakeFromNib() {
        super.awakeFromNib()
        configureButton()
    }

    // MARK: - Private Methods
    
    private func configureButton() {
        backgroundColor = PaletteColors.passButtonBackground
        tintColor = .white
        
        layer.shadowOpacity = 0.16
        layer.shadowOffset = CGSize(width: 0, height: 3)
        layer.shadowColor = UIColor.gray.cgColor
        layer.shadowRadius = 6
        layer.cornerRadius = frame.height / 2
        layer.opacity = 0.9
        
        titleLabel?.font = UIFont.customFont(.robotoBoldFont(size: 18))
    }
}
