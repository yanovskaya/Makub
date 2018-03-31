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
    
    // MARK: - Public Methods
    
    func request(method: HTTPMethod,
                 url: String,
                 parameters: [String: String]? = nil,
                 timeout: TimeInterval = 5,
                 headers: [String: String] = [:],
                 completion: ((TransportCallResult) -> Void)?) {
        Alamofire.request(url,
                          method: method,
                          parameters: parameters,
                          encoding: URLEncoding.default,
                          headers: headers).responseData { response in
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
