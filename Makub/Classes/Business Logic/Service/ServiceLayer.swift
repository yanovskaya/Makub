//
//  ServiceLayer.swift
//  Makub
//
//  Created by Елена Яновская on 03.04.2018.
//  Copyright © 2018 Elena Yanovskaya. All rights reserved.
//

import Alamofire
import Foundation

final class ServiceLayer {
    
    static let shared = ServiceLayer()
    
    let authService: AuthService
    let userService: UserService
    let newsService: NewsService
    let gamesService: GamesService
    
    let requestManager: SessionManager = {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 5
        return SessionManager(configuration: configuration)
    }()
    
    let uploadManager: SessionManager = {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 20
        return SessionManager(configuration: configuration)
    }()
    
    private init() {
        authService = AuthServiceImpl()
        userService = UserServiceImpl()
        newsService = NewsServiceImpl()
        gamesService = GamesServiceImpl()
    }
    
}
