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
        let im = UIImage(named: Constants.newsImage)?.imageWithInsets(insets: UIEdgeInsetsMake(6, 0, -6, 0))
        
        let firstVc = newsStoryboard.viewController(NewsViewController.self)
        firstVc.tabBarItem = UITabBarItem(title: nil, image: im, tag: 0)
        
        var im2 = UIImage(named: Constants.ratingImage)?.imageWithInsets(insets: UIEdgeInsetsMake(10, 0, 0, 0))
        let secondVc = ratingStoryboard.viewController(RatingViewController.self)
        secondVc.tabBarItem = UITabBarItem(title: nil, image: im2, tag: 1)
        
        let controllerArray = [firstVc, secondVc]
        viewControllers = controllerArray.map { UINavigationController(rootViewController: $0) }
    }

}
