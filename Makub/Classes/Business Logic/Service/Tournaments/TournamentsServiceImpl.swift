//
//  TournamentsServiceImpl.swift
//  Makub
//
//  Created by Елена Яновская on 18.04.2018.
//  Copyright © 2018 Elena Yanovskaya. All rights reserved.
//

import Alamofire
import Foundation
import RealmSwift
import SwiftKeychainWrapper

final class TournamentsServiceImpl: TournamentsService {
    
    // MARK: - Constants
    
    private enum Constants {
        static let baseURL = "https://makub.ru/api"
        static let tokenParameter = "token"
        static let fromParameter = "from"
        static let countParameter = "count"
    }
    
    private enum EndPoint {
        static let tournaments = "/all_tournaments"
    }
    
    // MARK: - Private Properties
    
    private let sessionManager: SessionManager
    private let transport: Transport
    private let tournamentsParser = Parser<TournamentsResponse>()
    private let tournamentsRealmCache = RealmCache<Tournament>()
    
    // MARK: - Initialization
    
    init(sessionManager: SessionManager) {
        self.sessionManager = sessionManager
        transport = Transport(sessionManager: sessionManager)
    }
    
    // MARK: - Public Methods
    
    func obtainTournaments(useCache: Bool, from: Int, count: Int, completion: ((ServiceCallResult<TournamentsResponse>) -> Void)?) {
        guard let token = KeychainWrapper.standard.string(forKey: KeychainKeys.token) else {
            let error = NSError(domain: "", code: AdditionalErrors.tokenNotFound)
            completion?(ServiceCallResult.serviceFailure(error: error))
            return
        }
        let parameters = [Constants.tokenParameter: token,
                          Constants.fromParameter: from,
                          Constants.countParameter: count] as [String: Any]
        transport.request(method: .post, url: Constants.baseURL + EndPoint.tournaments, parameters: parameters) { [unowned self] transportResult in
            switch transportResult {
            case .transportSuccess(let payload):
                let resultBody = payload.resultBody
                let parseResult = self.tournamentsParser.parse(from: resultBody)
                switch parseResult {
                case .parserSuccess(let model):
                    if model.error == 0 {
                        completion?(ServiceCallResult.serviceSuccess(payload: model))
                    } else {
                        let error = NSError(domain: "", code: model.error)
                        completion?(ServiceCallResult.serviceFailure(error: error))
                    }
                case .parserFailure(let error):
                    if useCache {
                        self.obtainTournamentsRealmCache(error: error, completion: completion)
                    } else {
                        completion?(ServiceCallResult.serviceFailure(error: error))
                    }
                }
            case .transportFailure(let error):
                if useCache {
                    self.obtainTournamentsRealmCache(error: error, completion: completion)
                } else {
                    completion?(ServiceCallResult.serviceFailure(error: error))
                }
            }
        }
    }
    
    // MARK: - Private Methods
    
    private func obtainTournamentsRealmCache(error: NSError? = nil, completion: ((ServiceCallResult<TournamentsResponse>) -> Void)?) {
        if let tournamentsCache = self.tournamentsRealmCache.getCachedArray() {
            let tournamentsResponse = TournamentsResponse(tournaments: tournamentsCache, error: 0)
            completion?(ServiceCallResult.serviceSuccess(payload: tournamentsResponse))
        } else {
            guard let error = error else {
                completion?(ServiceCallResult.serviceFailure(error: NSError()))
                return
            }
            completion?(ServiceCallResult.serviceFailure(error: error))
        }
    }
}
