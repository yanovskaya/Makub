//
//  User.swift
//  Makub
//
//  Created by Елена Яновская on 11.03.2018.
//  Copyright © 2018 Elena Yanovskaya. All rights reserved.
//

import Foundation
import RealmSwift

/// Модельный объект пользователя.
final class User: Object, Decodable {
    @objc dynamic var error: Int = 0
    @objc dynamic var photo: String!
    
    private enum CodingKeys: String, CodingKey {
        case error
        case photo
    }
}
