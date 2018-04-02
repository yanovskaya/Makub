//
//  GamesResponse.swift
//  Makub
//
//  Created by Елена Яновская on 02.04.2018.
//  Copyright © 2018 Elena Yanovskaya. All rights reserved.
//

import Foundation

struct GamesResponse: Decodable {
    
    let games: [Games]!
    let error: Int
}
