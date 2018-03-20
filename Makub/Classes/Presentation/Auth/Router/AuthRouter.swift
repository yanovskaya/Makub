//
//  AuthRouter.swift
//  Makub
//
//  Created by Елена Яновская on 20.03.2018.
//  Copyright © 2018 Elena Yanovskaya. All rights reserved.
//

import UIKit

final class AuthRouter {
    
    // MARK: - Private Properties
    
    private let authStoryboard = UIStoryboard(with: StoryboardTitle.auth)
    
    // MARK: - Public Methods
    
    /// Auth -> Recover.
    func showRecoverVC(source authViewController: AuthViewController) {
        let recoverViewController = authStoryboard.viewController(RecoverViewController.self)
        authViewController.navigationController?.show(recoverViewController, sender: self)
    }
    
    /// Auth -> TabBar.
    func showTabBar() {
        UIView.transition(with: UIApplication.shared.keyWindow!, duration: 0.5, options: .transitionFlipFromRight, animations: {
            UIApplication.shared.keyWindow?.rootViewController = TabBarController()
        })
    }
}
