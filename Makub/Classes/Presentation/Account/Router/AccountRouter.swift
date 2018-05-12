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
    private let gamesStoryboard = UIStoryboard(with: StoryboardTitle.games)
    
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
    
    /// Account -> Edit Profile.
    func showEditProfileVC(source accountViewController: AccountViewController) {
        let editProfileViewController = accountStoryboard.viewController(EditProfileViewController.self)
        editProfileViewController.presentationModel.userViewModel = accountViewController.presentationModel.userViewModel
        accountViewController.present(editProfileViewController, animated: true)
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
    
    func showUserGameInfoVC(source userGamesViewController: UserGamesViewController, _ index: Int) {
        let userGameInfoViewController = accountStoryboard.viewController(UserGameInfoViewController.self)
        userGameInfoViewController.presentationModel.userViewModel = userGamesViewController.presentationModel.userViewModel
        userGameInfoViewController.presentationModel.gameId = userGamesViewController.presentationModel.gamesViewModels[index].id
        userGamesViewController.show(userGameInfoViewController, sender: self)
    }
    
    /// UserComments -> GameInfo.
    
    func showUserGameInfoVCFromComments(source userCommentsViewController: UserCommentsViewController, _ index: Int) {
        let userGameInfoViewController = accountStoryboard.viewController(UserGameInfoViewController.self)
        userGameInfoViewController.presentationModel.userViewModel = userCommentsViewController.presentationModel.userViewModel
        userGameInfoViewController.presentationModel.gameId = userCommentsViewController.presentationModel.commentsViewModels[index].gameId
        userCommentsViewController.show(userGameInfoViewController, sender: self)
    }
    
    /// GameInfo -> AddComment.
    func presentAddCommentVC(source userGameInfoViewController: UserGameInfoViewController) {
        let addCommentViewController = gamesStoryboard.viewController(AddCommentViewController.self)
        let presentationModel = userGameInfoViewController.presentationModel
        addCommentViewController.presentationModel.userViewModel = presentationModel.userViewModel
        addCommentViewController.presentationModel.gameInfoViewModel = presentationModel.gameInfoViewModel
        addCommentViewController.delegate = userGameInfoViewController
        userGameInfoViewController.present(addCommentViewController, animated: true)
    }
    
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
