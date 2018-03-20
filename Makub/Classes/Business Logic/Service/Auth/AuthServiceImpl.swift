//
//  AuthServiceImpl.swift
//  Makub
//
//  Created by Елена Яновская on 15.03.2018.
//  Copyright © 2018 Elena Yanovskaya. All rights reserved.
//

import Alamofire
import Foundation
import SwiftKeychainWrapper

final class AuthServiceImpl: AuthService {
    
    // MARK: - Constants
    
    private enum Constants {
        static let baseURL = "https://makub.ru/api"
        static let emailParameter = "email"
        static let usernameParameter = "login"
        static let passwordParameter = "pass"
    }
    
    private enum EndPoint {
        static let login = "/login"
        static let recover = "/password_recover"
    }
    
    // MARK: - Private Properties
    
    private let sessionManager: SessionManager
    private let transport: Transport
    private let serializer = Serializer()
    private let authParser = Parser<AuthResponse>()
    private let recoverParser = Parser<RecoverResponse>()
    
    // MARK: - Initialization
    
    init(sessionManager: SessionManager) {
        self.sessionManager = sessionManager
        transport = Transport(sessionManager: sessionManager)
    }
    
    // MARK: - Public Methods
    
    func authorizeUser(inputValues: [String],
                       completion: ((ServiceCallResult<AuthResponse>) -> Void)?) {
        let parameters = "\(Constants.usernameParameter)=\(inputValues[0])&\(Constants.passwordParameter)=\(inputValues[1])"
        let bodyParameters = serializer.serialize(parameters)
        transport.request(method: HTTPMethod.post.rawValue, url: Constants.baseURL + EndPoint.login, parameters: bodyParameters) { [unowned self] transportResult in
            switch transportResult {
            case .transportSuccess(let payload):
                let resultBody = payload.resultBody
                let parseResult = self.authParser.parse(from: resultBody)
                switch parseResult {
                case .parserSuccess(let model):
                    if model.error == 0 {
                        self.storeToken(model.token)
                        completion?(ServiceCallResult.serviceSuccess(payload: model))
                    } else {
                        // заглушка для тестирования
                        completion?(ServiceCallResult.serviceSuccess(payload: nil))
//                        let error = NSError(domain: "", code: model.error)
//                        completion?(ServiceCallResult.serviceFailure(error: error))
                    }
                case .parserFailure(let error):
                    completion?(ServiceCallResult.serviceFailure(error: error as NSError))
                }
            case .transportFailure(let error):
                completion?(ServiceCallResult.serviceFailure(error: error as NSError))
            }
        }
    }
    
    func recoverPassword(email: String, completion: ((ServiceCallResult<RecoverResponse>) -> Void)?) {
        let parameters = "\(Constants.emailParameter)=\(email)"
        let bodyParameters = serializer.serialize(parameters)
        transport.request(method: HTTPMethod.post.rawValue, url: Constants.baseURL + EndPoint.recover, parameters: bodyParameters) { [unowned self] transportResult in
            switch transportResult {
            case .transportSuccess(let payload):
                let resultBody = payload.resultBody
                let parseResult = self.recoverParser.parse(from: resultBody)
                switch parseResult {
                case .parserSuccess(let model):
                    if model.error == 1 {
                        completion?(ServiceCallResult.serviceSuccess(payload: nil))
                    } else {
                        // заглушка для тестирования
                        completion?(ServiceCallResult.serviceSuccess(payload: nil))
//                        let error = NSError(domain: "", code: model.error)
//                        completion?(ServiceCallResult.serviceFailure(error: error))
                    }
                case .parserFailure(let error):
                    completion?(ServiceCallResult.serviceFailure(error: error as NSError))
                }
            case .transportFailure(let error):
                completion?(ServiceCallResult.serviceFailure(error: error as NSError))
            }
        }
    }
    
    // MARK: - Private Methods
    
    private func storeToken(_ token: String) {
        KeychainWrapper.standard.set(token, forKey: KeychainKey.token)
    }
}
