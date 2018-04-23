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
                        let realm = self.convertToRealm(decodable: model)
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
                        completion?(ServiceCallResult.serviceFailure(error: error))
                    }
                }
            case .transportFailure(let error):
                if useCache {
                    self.obtainRealmCache(error: error, completion: completion)
                } else {
                    completion?(ServiceCallResult.serviceFailure(error: error))
                }
            }
        }
    }
    
    func obtainRealmCache(error: NSError? = nil, completion: ((ServiceCallResult<UserDecodable>) -> Void)?) {
        if let userCache = self.realmCache.getCachedObject() {
            let model = convertToDecodable(realm: userCache)
            completion?(ServiceCallResult.serviceSuccess(payload: model))
        } else {
            guard let error = error else {
                completion?(ServiceCallResult.serviceFailure(error: NSError()))
                return
            }
            completion?(ServiceCallResult.serviceFailure(error: error))
        }
    }
    
     // MARK: - Private Methods
    
    private func convertToDecodable(realm: User) -> UserDecodable {
        return UserDecodable(error: realm.error,
                             id: realm.id,
                             name: realm.name,
                             surname: realm.surname,
                             photo: realm.photo,
                             razryad: realm.razryad,
                             razryadFast: realm.razryadFast,
                             ratingOfPlayer: realm.ratingOfPlayer,
                             ratingFast: realm.ratingFast,
                             ratingVeryFast: realm.ratingVeryFast,
                             ratingClassic: realm.ratingClassic,
                             club: realm.club,
                             win: realm.win,
                             lose: realm.lose,
                             dost: Array(realm.dost))
    }
    
    private func convertToRealm(decodable model: UserDecodable) -> User {
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
        return realm
    }
}
