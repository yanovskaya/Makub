//
//  Transport.swift
//  Makub
//
//  Created by Елена Яновская on 03.04.2018.
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
    
    func request(method: HTTPMethod,
                 url: String,
                 parameters: [String: Any]? = nil,
                 headers: [String: String] = [:],
                 completion: ((TransportCallResult) -> Void)?) {
        sessionManager.request(url,
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
    
    
    func upload(method: HTTPMethod,
                url: String,
                parameters: [String: Any]? = nil,
                headers: [String: String] = [:],
                data: Data,
                name: String = "image",
                fileName: String = "file.jpg",
                mimeType: String = "image/jpg",
                completion: ((TransportCallResult) -> Void)?) {
        sessionManager.upload(multipartFormData: { multipartFormData in
            multipartFormData.append(data,
                                     withName: name,
                                     fileName: fileName,
                                     mimeType: mimeType)
            if let parameters = parameters {
                for (key, value) in parameters {
                    multipartFormData.append((value as AnyObject).data(using: String.Encoding.utf8.rawValue)!, withName: key)
                }
            }
        },
                         to: url,
                         method: method,
                         headers: headers) { result in
            switch result {
            case .success(let upload, _, _):
                upload.responseData { response in
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
            case .failure(let error):
                completion?(TransportCallResult.transportFailure(error: error as NSError))
            }
        }
    }
}
