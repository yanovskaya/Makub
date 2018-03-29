//
//  UserService.swift
//  Makub
//
//  Created by Елена Яновская on 23.03.2018.
//  Copyright © 2018 Elena Yanovskaya. All rights reserved.
//

import Foundation

protocol UserService: class {
    
    func obtainUserInfo(completion: ((ServiceCallResult<User>) -> Void)?)
    func obtainRealmCache(error: NSError?, completion: ((ServiceCallResult<User>) -> Void)?)
}
