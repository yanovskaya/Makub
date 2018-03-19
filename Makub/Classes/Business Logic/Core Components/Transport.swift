//
//  Transport.swift
//  Makub
//
//  Created by Елена Яновская on 15.03.2018.
//  Copyright © 2018 Elena Yanovskaya. All rights reserved.
//

import Alamofire
import Foundation

struct TransportResponseResult {
    let httpStatus: Int
    let headers: [AnyHashable: Any]
    let resultBody: Data
}

final class Transport {
    
    // MARK: - Private Properties
    
    private let sessionManager: SessionManager
    
    // MARK: - Initialization
    
    init(sessionManager: SessionManager) {
        self.sessionManager = sessionManager
    }
    
    // MARK: - Public Methods
    
    func request(method: String,
                 url: String,
                 parameters: Data? = nil,
                 timeout: TimeInterval = 5,
                 headers: [String: String] = [:],
                 completion: ((TransportCallResult) -> Void)?) {
        var request = URLRequest(url: URL(string: url)!)
        request.httpMethod = method
        request.httpBody = parameters
        request.allHTTPHeaderFields = headers
        request.timeoutInterval = timeout
        request.cachePolicy = .reloadIgnoringCacheData
        sessionManager.request(request).responseData { response in
            switch response.result {
            case .success(let resultData):
                do {
                    guard let statusCode = response.response?.statusCode,
                        let allHeaderFields = response.response?.allHeaderFields else { return }
                    switch statusCode {
                    case 200:
                        let payload = TransportResponseResult(httpStatus: statusCode,
                                                              headers: allHeaderFields,
                                                              resultBody: resultData)
                        completion?(TransportCallResult.transportSuccess(payload: payload))
                    default:
                        let error = NSError(domain: "", code: statusCode, userInfo: nil)
                        completion?(TransportCallResult.transportFailure(error: error as NSError))
                    }
                }
            case .failure(let error):
                completion?(TransportCallResult.transportFailure(error: error as NSError))
            }
        }
    }
    
}
