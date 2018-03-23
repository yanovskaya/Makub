//
//  User.swift
//  Makub
//
//  Created by Елена Яновская on 11.03.2018.
//  Copyright © 2018 Elena Yanovskaya. All rights reserved.
//

import Foundation

/// Модельный объект пользователя.
struct User: Decodable {
    var error: Int
    var photo: String!
    
    private enum CodingKeys: String, CodingKey {
        case error
        case photo
    }
}
