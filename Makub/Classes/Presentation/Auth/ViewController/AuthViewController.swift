//
//  ViewController.swift
//  Makub
//
//  Created by Елена Яновская on 11.03.2018.
//  Copyright © 2018 Elena Yanovskaya. All rights reserved.
//

import UIKit

final class AuthViewController: UIViewController {
    
    // MARK: - Constants
    
    private enum Constants {
        static let authBackgroundImage = "auth_background"
        static let logoImage = "logo"
    }
    
    // MARK: - IBOutlets
    
    @IBOutlet private var logoImageView: UIImageView!
    @IBOutlet private var backgoundImageView: UIImageView!
    
    // MARK: - ViewController lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        configureBackgroundImage()
        configureImageView()
    }
    
    // MARK: - Private Methods
    
    private func configureBackgroundImage() {
        backgoundImageView.image = UIImage(named: Constants.authBackgroundImage)
        backgoundImageView.contentMode = .scaleAspectFill
    }
    
    private func configureImageView() {
        logoImageView.contentMode = .scaleAspectFit
        ;logoImageView.tintColor = UIColor.white
        logoImageView.image = UIImage(named: Constants.logoImage)?.withRenderingMode(.alwaysTemplate)
        logoImageView.layer.opacity = 0.95
        
        logoImageView.layer.shadowOpacity = 0.16
        logoImageView.layer.shadowOffset = CGSize(width: 0, height: 3)
        logoImageView.layer.shadowColor = UIColor.gray.cgColor
        logoImageView.layer.shadowRadius = 6
    }

    private func configureTextFields() {
        
    }
}

