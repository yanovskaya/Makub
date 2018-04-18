//
//  ClubsServiceImpl.swift
//  Makub
//
//  Created by Елена Яновская on 18.04.2018.
//  Copyright © 2018 Elena Yanovskaya. All rights reserved.
//

import Alamofire
import Foundation
import RealmSwift
import SwiftKeychainWrapper

final class ClubsServiceImpl: ClubsService {
    
    // MARK: - Constants
    
    private enum Constants {
        static let baseURL = "https://makub.ru/api"
        static let tokenParameter = "token"
    }
    
    private enum EndPoint {
        static let clubs = "/all_clubs"
    }
    
    // MARK: - Private Properties
    
    private let sessionManager: SessionManager
    private let transport: Transport
    private let clubsParser = Parser<ClubsResponse>()
    private let clubsRealmCache = RealmCache<Club>()
    
    // MARK: - Initialization
    
    init(sessionManager: SessionManager) {
        self.sessionManager = sessionManager
        transport = Transport(sessionManager: sessionManager)
    }
    
    // MARK: - Public Methods
    
    func obtainClubs(useCache: Bool, completion: ((ServiceCallResult<ClubsResponse>) -> Void)?) {
        guard let token = KeychainWrapper.standard.string(forKey: KeychainKeys.token) else {
            let error = NSError(domain: "", code: AdditionalErrors.tokenNotFound)
            completion?(ServiceCallResult.serviceFailure(error: error))
            return
        }
        let parameters = [Constants.tokenParameter: token]
        transport.request(method: .post, url: Constants.baseURL + EndPoint.clubs, parameters: parameters) { [unowned self] transportResult in
            switch transportResult {
            case .transportSuccess(let payload):
                let resultBody = payload.resultBody
                let parseResult = self.clubsParser.parse(from: resultBody)
                switch parseResult {
                case .parserSuccess(let model):
                    if model.error == 0 {
                        self.clubsRealmCache.refreshCache(model.clubs)
                        completion?(ServiceCallResult.serviceSuccess(payload: model))
                    } else {
                        let error = NSError(domain: "", code: model.error)
                        completion?(ServiceCallResult.serviceFailure(error: error))
                    }
                case .parserFailure(let error):
                    if useCache {
                        self.obtainClubsRealmCache(error: error, completion: completion)
                    } else {
                        completion?(ServiceCallResult.serviceFailure(error: error))
                    }
                }
            case .transportFailure(let error):
                if useCache {
                    self.obtainClubsRealmCache(error: error, completion: completion)
                } else {
                    completion?(ServiceCallResult.serviceFailure(error: error))
                }
            }
        }
    }
    
    func obtainClubsRealmCache(error: NSError? = nil, completion: ((ServiceCallResult<ClubsResponse>) -> Void)?) {
        if let clubsCache = self.clubsRealmCache.getCachedArray() {
            let clubsResponse = ClubsResponse(clubs: clubsCache, error: 0)
            completion?(ServiceCallResult.serviceSuccess(payload: clubsResponse))
        } else {
            guard let error = error else {
                completion?(ServiceCallResult.serviceFailure(error: NSError()))
                return
            }
            completion?(ServiceCallResult.serviceFailure(error: error))
        }
    }
}
