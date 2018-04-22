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
    @objc dynamic var win: Int = 0
    @objc dynamic var lose: Int = 0
    @objc dynamic var photo: String!
    @objc dynamic var razryad: String!
    @objc dynamic var razryadFast: String!
    @objc dynamic var club: String!
    var dost = List<Achievement>()
}

struct UserDecodable: Decodable {
    
    let error: Int
    let id: String
    let name: String
    let surname: String
    let photo: String!
    let razryad: String!
    let razryadFast: String!
    let club: String!
    let win: Int
    let lose: Int
    let dost: [Achievement]
}

final class Achievement: Object, Decodable {
    @objc dynamic var name: String = ""
}
