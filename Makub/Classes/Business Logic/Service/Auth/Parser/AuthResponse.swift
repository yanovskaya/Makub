//
//  AuthResponse.swift
//  Makub
//
//  Created by Елена Яновская on 03.04.2018.
//  Copyright © 2018 Elena Yanovskaya. All rights reserved.
//

import Foundation

struct AuthResponse: Decodable {
    let error: Int
    let token: String!
}

struct RecoverResponse: Decodable {
    let error: Int
}
