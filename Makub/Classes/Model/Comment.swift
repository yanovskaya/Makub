//
//  Comment.swift
//  Makub
//
//  Created by Елена Яновская on 15.04.2018.
//  Copyright © 2018 Elena Yanovskaya. All rights reserved.
//

import Foundation

struct Comment: Decodable {
    
    let id: String
    let gameId: String
    let comment: String
    let playerId: String
    let time: String!
    let name: String
    let surname: String
    let photo: String!
}
