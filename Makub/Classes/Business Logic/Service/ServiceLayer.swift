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
    let gameInfoService: GameInfoService
    let tournamentsService: TournamentsService
    let clubsService: ClubsService
    let ratingService: RatingService
    
    let requestSessionManager: SessionManager
    let uploadSessionManager: SessionManager
    
    private init() {
        requestSessionManager = {
            let configuration = URLSessionConfiguration.default
            configuration.timeoutIntervalForRequest = 15
            return SessionManager(configuration: configuration)
        }()
        uploadSessionManager = {
            let configuration = URLSessionConfiguration.default
            configuration.timeoutIntervalForRequest = 30
            return SessionManager(configuration: configuration)
        }()
        
        authService = AuthServiceImpl(sessionManager: requestSessionManager)
        userService = UserServiceImpl(sessionManager: requestSessionManager)
        newsService = NewsServiceImpl(requestSessionManager: requestSessionManager,
                                      uploadSessionManager: uploadSessionManager)
        gamesService = GamesServiceImpl(sessionManager: requestSessionManager)
        gameInfoService = GameInfoServiceImpl(sessionManager: requestSessionManager)
        tournamentsService = TournamentsServiceImpl(sessionManager: requestSessionManager)
        clubsService = ClubsServiceImpl(sessionManager: requestSessionManager)
        ratingService = RatingServiceImpl(sessionManager: requestSessionManager)
    }
    
}
