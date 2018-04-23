//
//  UserGame.swift
//  Makub
//
//  Created by Елена Яновская on 23.04.2018.
//  Copyright © 2018 Elena Yanovskaya. All rights reserved.
//

import Foundation
import RealmSwift

final class UserGame: Object, Decodable {
    
    @objc dynamic var id: String! = nil
    @objc dynamic var ourScore: String! = nil
    @objc dynamic var hisScore: String! = nil
    @objc dynamic var gameType: String! = nil
    @objc dynamic var video: String! = nil
    @objc dynamic var name: String! = nil
    @objc dynamic var surname: String! = nil
    @objc dynamic var photo: String! = nil
    @objc dynamic var comments: String! = nil
}
