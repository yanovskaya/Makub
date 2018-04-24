//
//  UserCommentsCountResponse.swift
//  Makub
//
//  Created by Елена Яновская on 24.04.2018.
//  Copyright © 2018 Elena Yanovskaya. All rights reserved.
//

import Foundation

struct UserCommentsCountResponse: Decodable {
    
    let count: Int
    let error: Int
}
