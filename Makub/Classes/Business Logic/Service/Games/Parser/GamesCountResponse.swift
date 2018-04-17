//
//  GamesCountResponse.swift
//  Makub
//
//  Created by Елена Яновская on 09.04.2018.
//  Copyright © 2018 Elena Yanovskaya. All rights reserved.
//

import Foundation

struct GamesCountResponse: Decodable {
    
    let count: Int
    let error: Int
}
