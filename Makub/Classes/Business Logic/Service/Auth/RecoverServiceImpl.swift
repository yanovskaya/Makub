//
//  RecoverServiceImpl.swift
//  Makub
//
//  Created by Елена Яновская on 20.03.2018.
//  Copyright © 2018 Elena Yanovskaya. All rights reserved.
//

import Alamofire
import Foundation

final class RecoverServiceImpl: RecoverService {
    
    // MARK: - Constants
    
    private enum Constants {
        static let baseURL = "https://makub.ru/api"
        static let emailParameter = "login"
    }
    
    private enum EndPoint {
        static let login = "/password_recover"
    }
    
    // MARK: - Private Properties
    
    private let sessionManager: SessionManager
    private let transport: Transport
    private let serializer = Serializer()
    private let parser = Parser<RecoverResponse>()
    
    // MARK: - Initialization
    
    init(sessionManager: SessionManager) {
        self.sessionManager = sessionManager
        transport = Transport(sessionManager: sessionManager)
    }
    
    // MARK: - Public Methods
    
    func recoverPassword(email: String, completion: ((ServiceCallResult<RecoverResponse>) -> Void)?) {
        let parameters = "\(Constants.emailParameter)=\(email)"
        let bodyParameters = serializer.serialize(parameters)
        transport.request(method: HTTPMethod.post.rawValue, url: Constants.baseURL + EndPoint.login, parameters: bodyParameters) { [unowned self] transportResult in
            switch transportResult {
            case .transportSuccess(let payload):
                let resultBody = payload.resultBody
                let parseResult = self.parser.parse(from: resultBody)
                switch parseResult {
                case .parserSuccess(let model):
                    if model.error == 1 {
                        completion?(ServiceCallResult.serviceSuccess(payload: nil))
                    } else {
                        let error = NSError(domain: "", code: model.error)
                        completion?(ServiceCallResult.serviceFailure(error: error))
                    }
                case .parserFailure(let error):
                    completion?(ServiceCallResult.serviceFailure(error: error as NSError))
                }
            case .transportFailure(let error):
                completion?(ServiceCallResult.serviceFailure(error: error as NSError))
            }
        }
    }
    
}
