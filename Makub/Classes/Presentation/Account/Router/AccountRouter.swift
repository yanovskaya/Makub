//
//  AccountRouter.swift
//  Makub
//
//  Created by Елена Яновская on 21.04.2018.
//  Copyright © 2018 Elena Yanovskaya. All rights reserved.
//

import Foundation
import RealmSwift
import SwiftKeychainWrapper
import UIKit

final class AccountRouter {
    
    // MARK: - Private Properties

    private let authStoryboard = UIStoryboard(with: StoryboardTitle.auth)
    private let accountStoryboard = UIStoryboard(with: StoryboardTitle.account)
    
    private var realm: Realm? {
        return try? Realm()
    }
    
    // MARK: - Public Methods

    /// Account -> Achievements.
    func showAchievementsVC(source accountViewController: AccountViewController, _ index: Int) {
        let achievementsViewController = accountStoryboard.viewController(AchievementsViewController.self)
        achievementsViewController.presentationModel.userViewModel = accountViewController.presentationModel.userViewModel
        achievementsViewController.presentationModel.title = accountViewController.presentationModel.settingModels[index]
        accountViewController.show(achievementsViewController, sender: self)
    }
    
    /// Account -> UserGames.
    func showUserGamesVC(source accountViewController: AccountViewController, _ index: Int) {
        let userGamesViewController = accountStoryboard.viewController(UserGamesViewController.self)
        userGamesViewController.presentationModel.userViewModel = accountViewController.presentationModel.userViewModel
        userGamesViewController.presentationModel.title = accountViewController.presentationModel.settingModels[index]
        accountViewController.show(userGamesViewController, sender: self)
    }
    
    /// Account -> Comments.
    func showUserCommentsVC(source accountViewController: AccountViewController, _ index: Int) {
        let userCommentsViewController = accountStoryboard.viewController(UserCommentsViewController.self)
        userCommentsViewController.presentationModel.userViewModel = accountViewController.presentationModel.userViewModel
        userCommentsViewController.presentationModel.title = accountViewController.presentationModel.settingModels[index]
        accountViewController.show(userCommentsViewController, sender: self)
    }
    
    /// Exit.
    func exitToAuthorization() {
        removeAllStorage()
        let navigationController = UINavigationController()
        let authViewController = authStoryboard.viewController(AuthViewController.self)
        navigationController.viewControllers = [authViewController]
        UIView.transition(with: UIApplication.shared.keyWindow!, duration: 0.5, options: .transitionFlipFromRight, animations: {
            UIApplication.shared.keyWindow?.rootViewController = navigationController
        })
    }
    
    /// UserGames -> GameInfo.
    
    // MARK: - Private Methods
    
    private func removeAllStorage() {
        KeychainWrapper.standard.removeAllKeys()
        do {
            try? realm?.write {
                realm?.deleteAll()
            }
        }
    }
}
