//
//  GamesServiceImpl.swift
//  Makub
//
//  Created by Елена Яновская on 03.04.2018.
//  Copyright © 2018 Elena Yanovskaya. All rights reserved.
//

import Alamofire
import Foundation
import RealmSwift
import SwiftKeychainWrapper

final class GamesServiceImpl: GamesService {
    
    // MARK: - Constants
    
    private enum Constants {
        static let baseURL = "https://makub.ru/api"
        static let tokenParameter = "token"
        static let idParameter = "id"
        
        static let fromParameter = "from"
        static let toParameter = "to"
    }
    
    private enum EndPoint {
        static let allGames = "/all_games"
    }
    
    // MARK: - Private Properties
    
    private let transport = Transport()
    private let parser = Parser<GamesResponse>()
    private let realmCache = RealmCache<Games>()
    
    // MARK: - Public Methods
    
    func obtainAllGames(from: Int, to: Int, completion: ((ServiceCallResult<GamesResponse>) -> Void)?) {
        guard let token = KeychainWrapper.standard.string(forKey: KeychainKey.token) else {
            let error = NSError(domain: "", code: AdditionalError.tokenNotFound)
            completion?(ServiceCallResult.serviceFailure(error: error))
            return
        }
        let parameters = [Constants.tokenParameter: token,
                          Constants.fromParameter: from,
                          Constants.toParameter: to] as [String: Any]
        transport.request(method: .post, url: Constants.baseURL + EndPoint.allGames, parameters: parameters) { [unowned self] transportResult in
            switch transportResult {
            case .transportSuccess(let payload):
                let resultBody = payload.resultBody
                let parseResult = self.parser.parse(from: resultBody)
                switch parseResult {
                case .parserSuccess(let model):
                    if model.error == 0 {
                        self.realmCache.refreshCache(model.games)
                        completion?(ServiceCallResult.serviceSuccess(payload: model))
                    } else {
                        let error = NSError(domain: "", code: model.error)
                        completion?(ServiceCallResult.serviceFailure(error: error))
                    }
                case .parserFailure(let error):
                    self.obtainRealmCache(error: error, completion: completion)
                }
            case .transportFailure(let error):
                self.obtainRealmCache(error: error, completion: completion)
            }
        }
    }
    
    func obtainRealmCache(error: NSError? = nil, completion: ((ServiceCallResult<GamesResponse>) -> Void)?) {
        if let gamesCache = self.realmCache.getCachedArray() {
            let gamesResponse = GamesResponse(games: gamesCache, error: 0)
            completion?(ServiceCallResult.serviceSuccess(payload: gamesResponse))
        } else {
            guard let error = error else {
                completion?(ServiceCallResult.serviceFailure(error: NSError()))
                return
            }
            completion?(ServiceCallResult.serviceFailure(error: error))
        }
    }
    
    private func obtainStageById() {}
    
    //private func
}
