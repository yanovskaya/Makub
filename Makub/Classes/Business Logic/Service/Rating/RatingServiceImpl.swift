//
//  RatingServiceImpl.swift
//  Makub
//
//  Created by Елена Яновская on 19.04.2018.
//  Copyright © 2018 Elena Yanovskaya. All rights reserved.
//

import Alamofire
import Foundation
import RealmSwift
import SwiftKeychainWrapper

final class RatingServiceImpl: RatingService {
    
    // MARK: - Constants
    
    private enum Constants {
        static let baseURL = "https://makub.ru/api"
        static let tokenParameter = "token"
        static let typeParameter = "type"
        
        static let mainType = "main"
    }
    
    private enum EndPoint {
        static let rating = "/ratings"
    }
    
    // MARK: - Private Properties
    
    private let sessionManager: SessionManager
    private let transport: Transport
    private let ratingParser = Parser<RatingResponse>()
    private let ratingRealmCache = RealmCache<Rating>()
    
    // MARK: - Initialization
    
    init(sessionManager: SessionManager) {
        self.sessionManager = sessionManager
        transport = Transport(sessionManager: sessionManager)
    }
    
    // MARK: - Public Methods
    
    func obtainRating(useCache: Bool, completion: ((ServiceCallResult<RatingResponse>) -> Void)?) {
        guard let token = KeychainWrapper.standard.string(forKey: KeychainKeys.token) else {
            let error = NSError(domain: "", code: AdditionalErrors.tokenNotFound)
            completion?(ServiceCallResult.serviceFailure(error: error))
            return
        }
        let parameters = [Constants.tokenParameter: token,
                          Constants.typeParameter: Constants.mainType]
        transport.request(method: .post, url: Constants.baseURL + EndPoint.rating, parameters: parameters) { [unowned self] transportResult in
            switch transportResult {
            case .transportSuccess(let payload):
                let resultBody = payload.resultBody
                let parseResult = self.ratingParser.parse(from: resultBody)
                switch parseResult {
                case .parserSuccess(let model):
                    if model.error == 0 {
                        self.ratingRealmCache.refreshCache(model.rating)
                        completion?(ServiceCallResult.serviceSuccess(payload: model))
                    } else {
                        let error = NSError(domain: "", code: model.error)
                        completion?(ServiceCallResult.serviceFailure(error: error))
                    }
                case .parserFailure(let error):
                    if useCache {
                        self.obtainRatingRealmCache(error: error, completion: completion)
                    } else {
                        completion?(ServiceCallResult.serviceFailure(error: error))
                    }
                }
            case .transportFailure(let error):
                if useCache {
                    self.obtainRatingRealmCache(error: error, completion: completion)
                } else {
                    completion?(ServiceCallResult.serviceFailure(error: error))
                }
            }
        }
    }
    
    // MARK: - Private Methods
    
    private func obtainRatingRealmCache(error: NSError? = nil, completion: ((ServiceCallResult<RatingResponse>) -> Void)?) {
        if let ratingCache = self.ratingRealmCache.getCachedArray() {
            let ratingResponse = RatingResponse(rating: ratingCache, error: 0)
            completion?(ServiceCallResult.serviceSuccess(payload: ratingResponse))
        } else {
            guard let error = error else {
                completion?(ServiceCallResult.serviceFailure(error: NSError()))
                return
            }
            completion?(ServiceCallResult.serviceFailure(error: error))
        }
    }
}
