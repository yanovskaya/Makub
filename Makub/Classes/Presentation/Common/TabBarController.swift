//
//  TabBarController.swift
//  Makub
//
//  Created by Елена Яновская on 20.03.2018.
//  Copyright © 2018 Elena Yanovskaya. All rights reserved.
//

import UIKit

final class TabBarController: UITabBarController {
    
    // MARK: - Private Properties
    
    private let newsStoryboard = UIStoryboard(with: StoryboardTitle.news)
    private let ratingStoryboard = UIStoryboard(with: StoryboardTitle.rating)

    override func viewDidLoad() {
        super.viewDidLoad()

        createTabBarController()
    }
    
    func createTabBarController() {
        let firstVc = newsStoryboard.viewController(NewsViewController.self)
        firstVc.tabBarItem = UITabBarItem(tabBarSystemItem: .featured, tag: 0)
        
        let secondVc = ratingStoryboard.viewController(RatingViewController.self)
        secondVc.tabBarItem = UITabBarItem(tabBarSystemItem: .downloads, tag: 1)
        
        let controllerArray = [firstVc, secondVc]
        viewControllers = controllerArray.map { UINavigationController(rootViewController: $0) }
    }

}
