//
//  TabBarController.swift
//  Makub
//
//  Created by Елена Яновская on 20.03.2018.
//  Copyright © 2018 Elena Yanovskaya. All rights reserved.
//

import PKHUD
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
    
    private let presentationModel = TabBarPresentationModel()

    // MARK: - ViewController lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tabBar.barTintColor = .white
        navigationController?.isNavigationBarHidden = true
        view.backgroundColor = PaletteColors.blueBackground
        prepareTabBarController()
        presentationModel.obtainUserInfo { }
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        bindEvents()
    }
    
    // MARK: - Private Properties
    
    private func bindEvents() {
        presentationModel.changeStateHandler = { [weak self] status in
            switch status {
            case .loading:
                HUD.show(.progress)
            case .rich:
                self?.createTabBarController()
                HUD.hide()
            case .error (let code):
                switch code {
                default:
                    HUD.show(.labeledError(title: ErrorDescription.title.rawValue, subtitle: ErrorDescription.server.rawValue))
                }
                HUD.hide(afterDelay: 1.0)
            }
        }
    }
    
    var controllerArray: [UIViewController]!
    
    private func prepareTabBarController() {
        let im = UIImage(named: Constants.newsImage)?.imageWithInsets(insets: UIEdgeInsetsMake(6, 0, -6, 0))
        
        let firstVc = newsStoryboard.viewController(NewsViewController.self)
        firstVc.tabBarItem = UITabBarItem(title: nil, image: im, tag: 0)
        
        var im2 = UIImage(named: Constants.ratingImage)?.imageWithInsets(insets: UIEdgeInsetsMake(10, 0, 0, 0))
        let secondVc = ratingStoryboard.viewController(RatingViewController.self)
        secondVc.tabBarItem = UITabBarItem(title: nil, image: im2, tag: 1)
        controllerArray = [firstVc, secondVc]
        viewControllers?.append(controllerArray.first!)
    }
    
    private func createTabBarController() {
        viewControllers?.append(controllerArray.last!)
    }

}
