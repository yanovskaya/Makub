//
//  UserServiceImpl.swift
//  Makub
//
//  Created by Елена Яновская on 03.04.2018.
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
    private let parser = Parser<UserDecodable>()
    private let realmCache = RealmCache<User>()
    
    // MARK: - Initialization
    
    init(sessionManager: SessionManager) {
        self.sessionManager = sessionManager
        transport = Transport(sessionManager: sessionManager)
    }
    
    // MARK: - Public Methods
    
    func obtainUserInfo(useCache: Bool, completion: ((ServiceCallResult<UserDecodable>) -> Void)?) {
        guard let token = KeychainWrapper.standard.string(forKey: KeychainKeys.token) else {
            let error = NSError(domain: "", code: AdditionalErrors.tokenNotFound)
            completion?(ServiceCallResult.serviceFailure(error: error))
            return
        }
        let parameters = [Constants.tokenParameter: token]
        transport.request(method: .post, url: Constants.baseURL + EndPoint.checktoken, parameters: parameters) { [unowned self] transportResult in
            switch transportResult {
            case .transportSuccess(let payload):
                let resultBody = payload.resultBody
                let parseResult = self.parser.parse(from: resultBody)
                switch parseResult {
                case .parserSuccess(let model):
                    if model.error == 0 {
                        let realm = User()
                        realm.id = model.id
                        realm.club = model.club
                        realm.name = model.name
                        realm.surname = model.surname
                        realm.photo = model.photo
                        realm.razryad = model.razryad
                        realm.error = model.error
                        realm.razryadFast = model.razryadFast
                        for achievement in model.dost {
                            realm.dost.append(achievement)
                        }
                        self.realmCache.refreshCache(realm)
                        completion?(ServiceCallResult.serviceSuccess(payload: model))
                    } else {
                        let error = NSError(domain: "", code: model.error)
                        completion?(ServiceCallResult.serviceFailure(error: error))
                    }
                case .parserFailure(let error):
                    if useCache {
                        self.obtainRealmCache(error: error, completion: completion)
                    } else {
                        completion?(ServiceCallResult.serviceFailure(error: NSError()))
                    }
                }
            case .transportFailure(let error):
                if useCache {
                    self.obtainRealmCache(error: error, completion: completion)
                } else {
                    completion?(ServiceCallResult.serviceFailure(error: NSError()))
                }
            }
        }
    }
    
    func obtainRealmCache(error: NSError? = nil, completion: ((ServiceCallResult<UserDecodable>) -> Void)?) {
        if let userCache = self.realmCache.getCachedObject() {
            let model = UserDecodable(error: userCache.error,
                                      id: userCache.id,
                                      name: userCache.name,
                                      surname: userCache.surname,
                                      photo: userCache.photo,
                                      razryad: userCache.razryad,
                                      razryadFast: userCache.razryadFast,
                                      club: userCache.club,
                                      dost: Array(userCache.dost))
            completion?(ServiceCallResult.serviceSuccess(payload: model))
        } else {
            completion?(ServiceCallResult.serviceFailure(error: NSError()))
        }
    }
    
}
