//
//  AuthViewModel.swift
//  Makub
//
//  Created by Елена Яновская on 16.03.2018.
//  Copyright © 2018 Elena Yanovskaya. All rights reserved.
//

import Foundation

struct AuthViewModel {
    
    // MARK: - Public Properties
    
    let token: String
    
    // MARK: - Initialization
    
    init(token: String) {
        self.token = token
    }
}
