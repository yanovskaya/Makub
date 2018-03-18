//
//  AppDelegate.swift
//  Makub
//
//  Created by Елена Яновская on 11.03.2018.
//  Copyright © 2018 Elena Yanovskaya. All rights reserved.
//

import UIKit

@UIApplicationMain
final class AppDelegate: UIResponder, UIApplicationDelegate {

    // MARK: - Properties
    
    var window: UIWindow?
    
    private let navigationController = UINavigationController()
    private let authStoryboard = UIStoryboard.init(with: StoryboardTitle.auth)
    
    private var authViewController: UIViewController {
        return authStoryboard.viewController(AuthViewController.self)
    }

    // MARK: - App lifecycle
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        navigationController.viewControllers = [authViewController]
        self.window?.rootViewController = navigationController
        self.window?.makeKeyAndVisible()
        
        return true
    }
    
}
