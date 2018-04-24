//
//  AccountRouter.swift
//  Makub
//
//  Created by Елена Яновская on 21.04.2018.
//  Copyright © 2018 Elena Yanovskaya. All rights reserved.
//

import Foundation
import UIKit

final class AccountRouter {
    
    // MARK: - Private Properties
    
    private let accountStoryboard = UIStoryboard(with: StoryboardTitle.account)
    
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
    
    /// UserGames -> GameInfo.
}
