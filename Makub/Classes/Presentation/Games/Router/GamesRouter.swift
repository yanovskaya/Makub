//
//  GamesRouter.swift
//  Makub
//
//  Created by Елена Яновская on 06.04.2018.
//  Copyright © 2018 Elena Yanovskaya. All rights reserved.
//

import Foundation
import UIKit

final class GamesRouter {
    
    // MARK: - Private Properties
    
    private let gamesStoryboard = UIStoryboard(with: StoryboardTitle.games)
    
    // MARK: - Public Methods
    
    /// Games -> FilterGames.
    func presentFilterGamesVC(source gamesViewController: GamesViewController) {
        let filterGamesViewController = gamesStoryboard.viewController(FilterGamesViewController.self)
        filterGamesViewController.chosenOptions = gamesViewController.presentationModel.chosenOptions
        filterGamesViewController.presentationModel.clubViewModels = gamesViewController.presentationModel.clubViewModels
        filterGamesViewController.delegate = gamesViewController
        gamesViewController.present(filterGamesViewController, animated: true)
    }
    
    /// Games -> GameInfo.
    func showGameInfoVC(source gamesViewController: GamesViewController, _ index: Int) {
        let gameInfoViewController = gamesStoryboard.viewController(GameInfoViewController.self)
        gameInfoViewController.presentationModel.gameViewModel = gamesViewController.presentationModel.gamesViewModels[index]
        gamesViewController.show(gameInfoViewController, sender: self)
    }
    
    func presentAddCommentVC(source gameInfoViewController: GameInfoViewController) {
    }
    
}
