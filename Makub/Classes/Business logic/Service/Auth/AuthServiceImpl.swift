//
//  AuthServiceImpl.swift
//  Makub
//
//  Created by Елена Яновская on 15.03.2018.
//  Copyright © 2018 Elena Yanovskaya. All rights reserved.
//

import Alamofire
import Foundation

final class AuthServiceImpl: AuthService {
    
    // MARK: - Constants
    
    private enum Constants {
        static let baseURL = "https://makub.ru/api"
        static let usernameParameter = "login"
        static let passwordParameter = "pass"
    }
    
    private enum EndPoint {
        static let login = "/login"
    }
    
    // MARK: - Private Properties
    
    private let sessionManager: SessionManager
    private let transport: Transport
    private let serializer = Serializer()
    private let parser = Parser<AuthResponse>()
    
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
                print("tr success")
                let resultBody = payload.resultBody
                let parseResult = self.parser.parse(from: resultBody)
                switch parseResult {
                case .parserSuccess(let model):
                    print(model)
                    print()
                    print(model.error)
                    completion?(ServiceCallResult.serviceSuccess(payload: model))
                case .parserFailure(let error):
                    print("parse error")
                    completion?(ServiceCallResult.serviceFailure(error: error as NSError))
                }
            case .transportFailure(let error):
                print("tr error")
                completion?(ServiceCallResult.serviceFailure(error: error as NSError))
            }
        }
    }
    
}
