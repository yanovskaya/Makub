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
}
