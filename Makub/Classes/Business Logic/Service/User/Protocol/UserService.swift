//
//  UserService.swift
//  Makub
//
//  Created by Елена Яновская on 03.04.2018.
//  Copyright © 2018 Elena Yanovskaya. All rights reserved.
//

import Foundation

protocol UserService: class {
    
    func obtainUserInfo(useCache: Bool, completion: ((ServiceCallResult<UserDecodable>) -> Void)?)
    func obtainRealmCache(error: NSError?, completion: ((ServiceCallResult<UserDecodable>) -> Void)?)
}
