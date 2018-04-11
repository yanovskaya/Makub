//
//  AppDelegate.swift
//  Makub
//
//  Created by Елена Яновская on 11.03.2018.
//  Copyright © 2018 Elena Yanovskaya. All rights reserved.
//

import Kingfisher
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
        setInitialVC()
        ImageCache.default.maxDiskCacheSize = 50 * 1024 * 1024
        return true
    }
    
    // MARK: - Private Methods
    
    private func setInitialVC() {
        window = UIWindow(frame: UIScreen.main.bounds)
        
        let token = KeychainWrapper.standard.string(forKey: KeychainKeys.token)
        let wasLaunchBefore = UserDefaults.standard.bool(forKey: UserDefaultsKeys.wasLaunchBefore)
        
        // Токена нет и приложение до этого не запускалось.
        if token == nil && !wasLaunchBefore {
            UserDefaults.standard.set(true, forKey: UserDefaultsKeys.wasLaunchBefore)
            navigationController.viewControllers = [authViewController]
            window?.rootViewController = navigationController
            
            // Токен есть и приложение до этого не запускалось.
        } else if !wasLaunchBefore {
            KeychainWrapper.standard.removeAllKeys()
            UserDefaults.standard.set(true, forKey: UserDefaultsKeys.wasLaunchBefore)
            navigationController.viewControllers = [authViewController]
            window?.rootViewController = navigationController
            
            // Токен есть и приложение до этого запускалось.
        } else {
            window?.rootViewController = TabBarController()
        }
        
        window?.makeKeyAndVisible()
    }
    
}
