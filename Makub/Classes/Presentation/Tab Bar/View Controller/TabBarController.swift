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
    }
    
    // MARK: - Private Properties
    
    private let newsStoryboard = UIStoryboard(with: StoryboardTitle.news)
    private let ratingStoryboard = UIStoryboard(with: StoryboardTitle.rating)
    
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
        
        let controllerArray = [newsVC, ratingVC]
        viewControllers = controllerArray.map { UINavigationController(rootViewController: $0) }
    }

}
