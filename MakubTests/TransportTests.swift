//
//  TransportTests.swift
//  MakubTests
//
//  Created by Елена Яновская on 02.05.2018.
//  Copyright © 2018 Elena Yanovskaya. All rights reserved.
//

import Alamofire
@testable import Makub
import SwiftKeychainWrapper
import XCTest

class TransportTests: XCTestCase {
    
    private var requestSessionManager: SessionManager!
    private var transport: Transport!
    
    override func setUp() {
        super.setUp()
        requestSessionManager = {
            let configuration = URLSessionConfiguration.default
            configuration.timeoutIntervalForRequest = 15
            return SessionManager(configuration: configuration)
        }()
        transport = Transport(sessionManager: requestSessionManager)
    }
    
    override func tearDown() {
        requestSessionManager = nil
        transport = nil
        super.tearDown()
    }
    
    func testNewsGetsHTTPStatusCode200() {
        let URL = "https://makub.ru/api/news"
        let tokenParameter = "token"
        guard let token = KeychainWrapper.standard.string(forKey: KeychainKeys.token) else { return }
        let promise = expectation(description: "Status code: 200")
        transport.request(method: .post,
                          url: URL,
                          parameters: [tokenParameter: token as Any]) { transportResult in
                            switch transportResult {
                            case .transportSuccess:
                                promise.fulfill()
                            case .transportFailure(let error):
                                XCTFail("Status code: \(error.code)")
                            }
        }
        waitForExpectations(timeout: 20, handler: nil)
    }
    
}
