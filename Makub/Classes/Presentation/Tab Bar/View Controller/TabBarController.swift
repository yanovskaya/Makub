//
//  TabBarController.swift
//  Makub
//
//  Created by Елена Яновская on 20.03.2018.
//  Copyright © 2018 Elena Yanovskaya. All rights reserved.
//

import UIKit

final class TabBarController: UITabBarController {
    
    // MARK: - Constants
    
    private enum Constants {
        static var newsImage = "newspaper"
        static var ratingImage = "star"
        static var gamesImage = "fighting"
    }
    
    // MARK: - Private Properties
    
    private let newsStoryboard = UIStoryboard(with: StoryboardTitle.news)
    private let ratingStoryboard = UIStoryboard(with: StoryboardTitle.rating)
    private let gamesStoryboard = UIStoryboard(with: StoryboardTitle.games)
    
    // MARK: - ViewController lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tabBar.barTintColor = .white
        navigationController?.isNavigationBarHidden = true
        createTabBarController()
    }

    // MARK: - Private Properties
    
    private func createTabBarController() {
        let newsItem = UIImage(named: Constants.newsImage)?.imageWithInsets(insets: UIEdgeInsets(top: 10, left: 0, bottom: 0, right: 0))
        let newsVC = newsStoryboard.viewController(NewsViewController.self)
        newsVC.tabBarItem = UITabBarItem(title: nil, image: newsItem, tag: 0)
        
        let ratingItem = UIImage(named: Constants.ratingImage)?.imageWithInsets(insets: UIEdgeInsets(top: 10, left: 0, bottom: 0, right: 0))
        let ratingVC = ratingStoryboard.viewController(RatingViewController.self)
        ratingVC.tabBarItem = UITabBarItem(title: nil, image: ratingItem, tag: 1)
        
        let gamesItem = UIImage(named: Constants.gamesImage)?.imageWithInsets(insets: UIEdgeInsets(top: 10, left: 0, bottom: 0, right: 0))
        let gamesVC = gamesStoryboard.viewController(GamesViewController.self)
        gamesVC.tabBarItem = UITabBarItem(title: nil, image: gamesItem, tag: 2)
        
        let controllerArray = [newsVC, ratingVC, gamesVC]
        viewControllers = controllerArray.map { UINavigationController(rootViewController: $0) }
    }

}
