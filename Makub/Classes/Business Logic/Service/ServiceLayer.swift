//
//  ServiceLayer.swift
//  Makub
//
//  Created by Елена Яновская on 11.03.2018.
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
    
    private init() {
        authService = AuthServiceImpl()
        userService = UserServiceImpl()
        newsService = NewsServiceImpl()
        gamesService = GamesServiceImpl()
    }
    
}
