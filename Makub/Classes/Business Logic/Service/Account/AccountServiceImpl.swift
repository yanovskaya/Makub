//
//  AccountServiceImpl.swift
//  Makub
//
//  Created by Елена Яновская on 23.04.2018.
//  Copyright © 2018 Elena Yanovskaya. All rights reserved.
//

import Alamofire
import Foundation
import RealmSwift
import SwiftKeychainWrapper

final class AccountServiceImpl: AccountService {
    
    // MARK: - Constants
    
    private enum Constants {
        static let baseURL = "https://makub.ru/api"
        static let tokenParameter = "token"
        
        static let fromParameter = "from"
        static let toParameter = "to"
        static let idParameter = "id"
    }
    
    private enum EndPoint {
        static let games = "/my_games"
        static let gamesCount = "/my_games_count"
        static let comments = "/all_player_comments"
        static let commentsCount = "/all_player_comments_count"
    }
    
    // MARK: - Private Properties
    
    private let sessionManager: SessionManager
    private let transport: Transport
    private let gamesParser = Parser<UserGamesResponse>()
    
    private let commentsParser = Parser<UserCommentsResponse>()
    private let commentsCountParser = Parser<UserCommentsCountResponse>()
    
    private let gamesRealmCache = RealmCache<UserGame>()
    private let commentsRealmCache = RealmCache<UserComment>()
    
    // MARK: - Initialization
    
    init(sessionManager: SessionManager) {
        self.sessionManager = sessionManager
        transport = Transport(sessionManager: sessionManager)
    }
    
    // MARK: - Public Methods
    
    func obtainUserGames(from: Int, to: Int, useCache: Bool, completion: ((ServiceCallResult<UserGamesResponse>) -> Void)?) {
        guard let token = KeychainWrapper.standard.string(forKey: KeychainKeys.token) else {
            let error = NSError(domain: "", code: AdditionalErrors.tokenNotFound)
            completion?(ServiceCallResult.serviceFailure(error: error))
            return
        }
        let parameters = [Constants.tokenParameter: token,
                          Constants.fromParameter: from,
                          Constants.toParameter: to] as [String: Any]
        transport.request(method: .post, url: Constants.baseURL + EndPoint.games, parameters: parameters) { [unowned self] transportResult in
            switch transportResult {
            case .transportSuccess(let payload):
                let resultBody = payload.resultBody
                let parseResult = self.gamesParser.parse(from: resultBody)
                switch parseResult {
                case .parserSuccess(let model):
                    if model.error == 0 {
                        self.gamesRealmCache.refreshCache(model.games)
                        completion?(ServiceCallResult.serviceSuccess(payload: model))
                    } else {
                        let error = NSError(domain: "", code: model.error)
                        completion?(ServiceCallResult.serviceFailure(error: error))
                    }
                case .parserFailure(let error):
                    if useCache {
                        self.obtainGamesRealmCache(error: error, completion: completion)
                    } else {
                        completion?(ServiceCallResult.serviceFailure(error: error))
                    }
                }
            case .transportFailure(let error):
                if useCache {
                    self.obtainGamesRealmCache(error: error, completion: completion)
                } else {
                    completion?(ServiceCallResult.serviceFailure(error: error))
                }
            }
        }
    }
    
    func obtainUserCommentsCount(completion: ((ServiceCallResult<UserCommentsCountResponse>) -> Void)?) {
        guard let token = KeychainWrapper.standard.string(forKey: KeychainKeys.token) else {
            let error = NSError(domain: "", code: AdditionalErrors.tokenNotFound)
            completion?(ServiceCallResult.serviceFailure(error: error))
            return
        }
        let parameters = [Constants.tokenParameter: token]
        transport.request(method: .post, url: Constants.baseURL + EndPoint.commentsCount, parameters: parameters) { [unowned self] transportResult in
            switch transportResult {
            case .transportSuccess(let payload):
                let resultBody = payload.resultBody
                let parseResult = self.commentsCountParser.parse(from: resultBody)
                switch parseResult {
                case .parserSuccess(let model):
                    if model.error == 0 {
                        completion?(ServiceCallResult.serviceSuccess(payload: model))
                    } else {
                        let error = NSError(domain: "", code: model.error)
                        completion?(ServiceCallResult.serviceFailure(error: error))
                    }
                case .parserFailure(let error):
                    completion?(ServiceCallResult.serviceFailure(error: error))
                }
            case .transportFailure(let error):
                completion?(ServiceCallResult.serviceFailure(error: error))
            }
        }
    }
    
    func obtainUserComments(id: Int, from: Int, to: Int, useCache: Bool, completion: ((ServiceCallResult<UserCommentsResponse>) -> Void)?) {
        guard let token = KeychainWrapper.standard.string(forKey: KeychainKeys.token) else {
            let error = NSError(domain: "", code: AdditionalErrors.tokenNotFound)
            completion?(ServiceCallResult.serviceFailure(error: error))
            return
        }
        let parameters = [Constants.tokenParameter: token,
                          Constants.fromParameter: from,
                          Constants.toParameter: to,
                          Constants.idParameter: id] as [String: Any]
        transport.request(method: .post, url: Constants.baseURL + EndPoint.comments, parameters: parameters) { [unowned self] transportResult in
            switch transportResult {
            case .transportSuccess(let payload):
                let resultBody = payload.resultBody
                let parseResult = self.commentsParser.parse(from: resultBody)
                switch parseResult {
                case .parserSuccess(let model):
                    if model.error == 0 {
                        self.commentsRealmCache.refreshCache(model.comments)
                        completion?(ServiceCallResult.serviceSuccess(payload: model))
                    } else {
                        let error = NSError(domain: "", code: model.error)
                        completion?(ServiceCallResult.serviceFailure(error: error))
                    }
                case .parserFailure(let error):
                    if useCache {
                        self.obtainCommentsRealmCache(error: error, completion: completion)
                    } else {
                        completion?(ServiceCallResult.serviceFailure(error: error))
                    }
                }
            case .transportFailure(let error):
                if useCache {
                    self.obtainCommentsRealmCache(error: error, completion: completion)
                } else {
                    completion?(ServiceCallResult.serviceFailure(error: error))
                }
            }
        }
    }
    
    // MARK: - Private Methods
    
    private func obtainGamesRealmCache(error: NSError? = nil, completion: ((ServiceCallResult<UserGamesResponse>) -> Void)?) {
        if let gamesCache = self.gamesRealmCache.getCachedArray() {
            let gamesResponse = UserGamesResponse(games: gamesCache, error: 0)
            completion?(ServiceCallResult.serviceSuccess(payload: gamesResponse))
        } else {
            guard let error = error else {
                completion?(ServiceCallResult.serviceFailure(error: NSError()))
                return
            }
            completion?(ServiceCallResult.serviceFailure(error: error))
        }
    }
    
    private func obtainCommentsRealmCache(error: NSError? = nil, completion: ((ServiceCallResult<UserCommentsResponse>) -> Void)?) {
        if let commentsCache = self.commentsRealmCache.getCachedArray() {
            let commentsResponse = UserCommentsResponse(comments: commentsCache, error: 0)
            completion?(ServiceCallResult.serviceSuccess(payload: commentsResponse))
        } else {
            guard let error = error else {
                completion?(ServiceCallResult.serviceFailure(error: NSError()))
                return
            }
            completion?(ServiceCallResult.serviceFailure(error: error))
        }
    }
}
