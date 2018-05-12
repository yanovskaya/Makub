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
    private let tournamentsStoryboard = UIStoryboard(with: StoryboardTitle.tournaments)
    
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
    
    /// GameInfo -> AddComment.
    func presentAddCommentVC(source gameInfoViewController: GameInfoViewController) {
        let addCommentViewController = gamesStoryboard.viewController(AddCommentViewController.self)
        let presentationModel = gameInfoViewController.presentationModel
        addCommentViewController.presentationModel.userViewModel = presentationModel.userViewModel
        addCommentViewController.presentationModel.gameViewModel = presentationModel.gameViewModel
        addCommentViewController.delegate = gameInfoViewController
        gameInfoViewController.present(addCommentViewController, animated: true)
    }
    
    /// Games -> Tournaments.
    func showTournamentsVC(source gamesViewController: GamesViewController) {
    let tournamentsViewController = tournamentsStoryboard.viewController(TournamentsViewController.self)
    let transition = CATransition()
    transition.type = kCATransitionReveal
    transition.subtype = kCATransitionFromLeft
    transition.duration = 0.4
    transition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
    gamesViewController.navigationController?.view.layer.add(transition, forKey: nil)
        gamesViewController.navigationController?.pushViewController(tournamentsViewController, animated: false)
    }
    
}
