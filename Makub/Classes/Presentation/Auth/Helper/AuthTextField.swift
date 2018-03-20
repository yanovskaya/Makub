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
    
    private enum LayoutConstants {
        static let imageWidth: CGFloat = 25
        static let leadingDistance: CGFloat = 10
        static let standard: CGFloat = 8
    }
    // MARK: - Private Properties
    
    private let imageView = UIImageView()
    
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
        let offset = LayoutConstants.standard + LayoutConstants.leadingDistance + imageView.frame.width
        let padding = UIEdgeInsets(top: 0, left: offset, bottom: 0, right: offset)
        return UIEdgeInsetsInsetRect(bounds, padding)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        let offset = 16 + imageView.frame.width
        let padding = UIEdgeInsets(top: 0, left: offset, bottom: 0, right: offset)
        return UIEdgeInsetsInsetRect(bounds, padding)
    }
    
    func attributePlaceholder() {
        guard let placeholder = placeholder else { return }
        let color = UIColor.white.withAlphaComponent(0.6)
        attributedPlaceholder = NSAttributedString(string: placeholder, attributes: [NSAttributedStringKey.foregroundColor: color])
    }
    
    func addImage(_ imageName: String, color: UIColor = .white, opacity: Float = 1) {
        let image = UIImage(named: imageName)?.withRenderingMode(.alwaysTemplate)
        imageView.image = image
        imageView.layer.opacity = opacity
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = color
        addSubview(imageView)
        
        configureImageViewConstraints()
    }
    
    // MARK: - Private Methods
    
    private func configureBorder() {
        layer.borderWidth = 1
        layer.borderColor = PaletteColors.borderAuthTextField.withAlphaComponent(0.6).cgColor
        layer.cornerRadius = frame.height / 2
    }
    
    private func configureShadow() {
        layer.shadowOpacity = 0.16
        layer.shadowOffset = CGSize(width: 0, height: 3)
        layer.shadowColor = UIColor.gray.cgColor
        layer.shadowRadius = 6
    }
    
    private func configureText() {
        font = UIFont.customFont(.robotoLightFont(size: 16))
        textColor = .white
        textAlignment = .center
    }
    
    private func configureImageViewConstraints() {
        imageView.translatesAutoresizingMaskIntoConstraints = false
        let widthConstraint = imageView.widthAnchor.constraint(equalToConstant: LayoutConstants.imageWidth)
        let heightConstraint = imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor)
        let centerYConstraint = imageView.centerYAnchor.constraint(equalTo: centerYAnchor)
        let leadingConstraint = imageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: LayoutConstants.leadingDistance)
        
        NSLayoutConstraint.activate([widthConstraint, heightConstraint, centerYConstraint, leadingConstraint])
    }
    
    private func clearBachground() {
        backgroundColor = .clear
    }
    
}
