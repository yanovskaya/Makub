//
//  RecoverService.swift
//  Makub
//
//  Created by Елена Яновская on 20.03.2018.
//  Copyright © 2018 Elena Yanovskaya. All rights reserved.
//

import Foundation

protocol RecoverService: class {
    
    func recoverPassword(email: String, completion: ((ServiceCallResult<RecoverResponse>) -> Void)?)
}
