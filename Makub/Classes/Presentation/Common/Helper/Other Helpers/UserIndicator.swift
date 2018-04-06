//
//  UserIndicator.swift
//  Makub
//
//  Created by Елена Яновская on 07.04.2018.
//  Copyright © 2018 Elena Yanovskaya. All rights reserved.
//

import Foundation
import Kingfisher

struct UserIndicator: Indicator {
    
    // MARK: - Constants
    
    private enum Constants {
        static let userImage = "photo_default"
    }
    
    // MARK: - Public Properties
    
    let view: UIView = UIView()
    let imageView = UIImageView()
    
    // MARK: - Initialization
    
    init() {
        imageView.image = UIImage(named: Constants.userImage)
        imageView.contentMode =  .scaleAspectFit
        view.addSubview(imageView)
    }
    
    // MARK: - Public Methods
    
    func startAnimatingView() {
        configureConstraints()
        view.isHidden = false
    }
    
    func stopAnimatingView() { view.isHidden = true }
    
    // MARK: - Private Methods
    
    private func configureConstraints() {
        imageView.translatesAutoresizingMaskIntoConstraints = false
        let topConstraint = imageView.topAnchor.constraint(equalTo: view.topAnchor)
        let bottomConstraint = imageView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        let trailingConstraint = imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        let leadingConstraint = imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor)
        
        NSLayoutConstraint.activate([topConstraint, bottomConstraint, leadingConstraint, trailingConstraint])
    }
}
