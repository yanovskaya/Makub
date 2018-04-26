//
//  User.swift
//  Makub
//
//  Created by Елена Яновская on 11.03.2018.
//  Copyright © 2018 Elena Yanovskaya. All rights reserved.
//

import Foundation
import RealmSwift

final class User: Object {
    
    @objc dynamic var error: Int = 0
    @objc dynamic var id: String = ""
    @objc dynamic var name: String = ""
    @objc dynamic var surname: String = ""
    @objc dynamic var country: String = ""
    @objc dynamic var town: String = ""
    @objc dynamic var facebook: String = ""
    @objc dynamic var telegram: String = ""
    @objc dynamic var vk: String = ""
    @objc dynamic var twitter: String = ""
    @objc dynamic var instagram: String = ""
    @objc dynamic var win: Int = 0
    @objc dynamic var lose: Int = 0
    @objc dynamic var photo: String!
    @objc dynamic var razryad: String!
    @objc dynamic var razryadFast: String!
    @objc dynamic var ratingOfPlayer: String = ""
    @objc dynamic var ratingFast: String = ""
    @objc dynamic var ratingVeryFast: String = ""
    @objc dynamic var ratingClassic: String = ""
    @objc dynamic var club: String = ""
    var dost = List<Achievement>()
}

struct UserDecodable: Decodable {
    
    let error: Int
    let id: String
    let name: String
    let surname: String
    let facebook: String
    let telegram: String
    let vk: String
    let instagram: String
    let twitter: String
    let photo: String!
    let razryad: String!
    let razryadFast: String!
    let ratingOfPlayer: String
    let ratingFast: String
    let ratingVeryFast: String
    let ratingClassic: String
    var club: String! = ""
    let win: Int
    let lose: Int
    let dost: [Achievement]
}

final class Achievement: Object, Decodable {
    @objc dynamic var name: String = ""
}
