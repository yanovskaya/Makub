//
//  Game.swift
//  Makub
//
//  Created by Елена Яновская on 02.04.2018.
//  Copyright © 2018 Elena Yanovskaya. All rights reserved.
//

import Foundation
import RealmSwift

final class Game: Object, Decodable {
    
    @objc dynamic var id: String! = nil
    @objc dynamic var score1: String! = nil
    @objc dynamic var score2: String! = nil
    @objc dynamic var type: String! = nil
    @objc dynamic var stage: String! = nil
    @objc dynamic var video: String! = nil
    @objc dynamic var clubId: String! = nil
    @objc dynamic var name1: String! = nil
    @objc dynamic var surname1: String! = nil
    @objc dynamic var photo1: String! = nil
    @objc dynamic var name2: String! = nil
    @objc dynamic var surname2: String! = nil
    @objc dynamic var photo2: String! = nil
    @objc dynamic var comments: String! = nil
    
    enum CodingKeys: String, CodingKey {
        case id
        case score1
        case score2
        case type
        case video
        case clubId = "club_id"
        case name1
        case surname1
        case photo1
        case name2
        case surname2
        case photo2
        case comments
    }
}
