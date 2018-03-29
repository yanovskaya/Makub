//
//  UserServiceImpl.swift
//  Makub
//
//  Created by Елена Яновская on 23.03.2018.
//  Copyright © 2018 Elena Yanovskaya. All rights reserved.
//

import Alamofire
import Foundation
import RealmSwift
import SwiftKeychainWrapper

final class UserServiceImpl: UserService {
    
    // MARK: - Constants
    
    private enum Constants {
        static let baseURL = "https://makub.ru/api"
        static let tokenParameter = "token"
    }
    
    private enum EndPoint {
        static let checktoken = "/checktoken"
    }
    
    // MARK: - Private Properties
    
    private let sessionManager: SessionManager
    private let transport: Transport
    private let serializer = Serializer()
    private let parser = Parser<User>()
    private let realmCache = RealmCache<User>()
    
    // MARK: - Initialization
    
    init(sessionManager: SessionManager) {
        self.sessionManager = sessionManager
        transport = Transport(sessionManager: sessionManager)
    }
    
    // MARK: - Public Methods
    
    func obtainUserInfo(completion: ((ServiceCallResult<User>) -> Void)?) {
        guard let token = KeychainWrapper.standard.string(forKey: KeychainKey.token) else { return }
        let parameters = "\(Constants.tokenParameter)=\(token)"
        let bodyParameters = serializer.serialize(parameters)
        transport.request(method: HTTPMethod.post.rawValue, url: Constants.baseURL + EndPoint.checktoken, parameters: bodyParameters) { [unowned self] transportResult in
            switch transportResult {
            case .transportSuccess(let payload):
                let resultBody = payload.resultBody
                let parseResult = self.parser.parse(from: resultBody)
                switch parseResult {
                case .parserSuccess(let model):
                    if model.error == 0 {
                        self.realmCache.refreshCache(model)
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
    
    func obtainRealmCache(error: NSError? = nil, completion: ((ServiceCallResult<User>) -> Void)?) {
        if let userCache = self.realmCache.getCachedObject() {
            completion?(ServiceCallResult.serviceSuccess(payload: userCache))
        } else {
            completion?(ServiceCallResult.serviceFailure(error: NSError()))
        }
    }
    
}
