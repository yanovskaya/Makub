//
//  AuthResponse.swift
//  Makub
//
//  Created by Елена Яновская on 15.03.2018.
//  Copyright © 2018 Elena Yanovskaya. All rights reserved.
//

import Foundation

struct AuthResponse: Decodable {
    let error: Int
    let token: String?
    
    private enum CodingKeys: String, CodingKey {
        case error
        case token
    }
}
