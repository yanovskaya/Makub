//
//  GameInfo.swift
//  Makub
//
//  Created by Елена Яновская on 30.04.2018.
//  Copyright © 2018 Elena Yanovskaya. All rights reserved.
//

import Foundation

struct GameInfo: Decodable {
    
    let id: String
    let score1: String
    let score2: String
    let type: String!
    let stage: String
    let video: String!
    let clubId: String
    let name1: String
    let surname1: String
    let photo1: String!
    let name2: String
    let surname2: String
    let photo2: String!
    let playTime: String
    let club1: String
    let club2: String
}
