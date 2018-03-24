//
//  AppDelegate.swift
//  Makub
//
//  Created by Елена Яновская on 11.03.2018.
//  Copyright © 2018 Elena Yanovskaya. All rights reserved.
//

import SwiftKeychainWrapper
import UIKit

@UIApplicationMain
final class AppDelegate: UIResponder, UIApplicationDelegate {

    // MARK: - Properties
    
    var window: UIWindow?
    
    private let navigationController = UINavigationController()
    private let authStoryboard = UIStoryboard(with: StoryboardTitle.auth)
    
    private var authViewController: UIViewController {
        return authStoryboard.viewController(AuthViewController.self)
    }

    // MARK: - App lifecycle
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        if KeychainWrapper.standard.string(forKey: KeychainKey.token) == nil {
            navigationController.viewControllers = [authViewController]
            window?.rootViewController = navigationController
        } else {
//            navigationController.viewControllers = [authViewController]
//            window?.rootViewController = navigationController
            window?.rootViewController = TabBarController()
        }
        window?.makeKeyAndVisible()
        return true
    }
    
}
