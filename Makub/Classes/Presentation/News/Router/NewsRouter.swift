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
        let presentationModel = newsViewController.presentationModel
        addNewsViewController.presentationModel = presentationModel
        addNewsViewController.delegate = newsViewController
        newsViewController.present(addNewsViewController, animated: true)
    }
}
