//
//  NewsRouter.swift
//  Makub
//
//  Created by Елена Яновская on 29.03.2018.
//  Copyright © 2018 Elena Yanovskaya. All rights reserved.
//

import UIKit

final class NewsRouter {
    
    // MARK: - Private Properties
    
    private let newsStoryboard = UIStoryboard(with: StoryboardTitle.news)
    
    // MARK: - Public Methods
    
    /// News -> AddNews.
    func presentAddNewsVC(source newsViewController: NewsViewController) {
        let addNewsViewController = newsStoryboard.viewController(AddNewsViewController.self)
        newsViewController.present(addNewsViewController, animated: true)
    }
    
    /// Auth -> TabBar.
    func showTabBar() {
        UIView.transition(with: UIApplication.shared.keyWindow!, duration: 0.5, options: .transitionFlipFromRight, animations: {
            UIApplication.shared.keyWindow?.rootViewController = TabBarController()
        })
    }
}
