//
//  AuthService.swift
//  Makub
//
//  Created by Елена Яновская on 15.03.2018.
//  Copyright © 2018 Elena Yanovskaya. All rights reserved.
//

import Foundation

protocol AuthService: class {
    
    func authorizeUser(inputValues: [String], completion: ((ServiceCallResult<AuthResponse>) -> Void)?)
    
    func recoverPassword(email: String, completion: ((ServiceCallResult<RecoverResponse>) -> Void)?)
}
