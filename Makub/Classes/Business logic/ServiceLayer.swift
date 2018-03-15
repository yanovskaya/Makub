//
//  ServiceLayer.swift
//  Makub
//
//  Created by Елена Яновская on 11.03.2018.
//  Copyright © 2018 Elena Yanovskaya. All rights reserved.
//

import Alamofire
import Foundation

final class ServiceLayer {
    
    static let shared = ServiceLayer()
    
    let sessionManager: SessionManager
    let sessionDelegate: SessionDelegate
    
    let authService: AuthService
    
    private init() {
        sessionDelegate = SessionDelegate()
        
        let session = URLSession(configuration: .default, delegate: sessionDelegate, delegateQueue: nil)
        sessionManager = SessionManager(session: session, delegate: sessionDelegate)!
        
        authService = AuthServiceImpl(sessionManager: sessionManager)
    }
    
}
