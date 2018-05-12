//
//  UserComment.swift
//  Makub
//
//  Created by Елена Яновская on 24.04.2018.
//  Copyright © 2018 Elena Yanovskaya. All rights reserved.
//

import Foundation
import RealmSwift

final class UserComment: Object, Decodable {
    
    @objc dynamic var game: String! = nil
    @objc dynamic var video: String! = nil
    @objc dynamic var ourScore: String! = nil
    @objc dynamic var hisScore: String! = nil
    @objc dynamic var comment: String! = nil
    @objc dynamic var opponent: String! = nil
    @objc dynamic var commentTime: String! = nil
    @objc dynamic var opponentName: String! = nil
    @objc dynamic var opponentSurname: String! = nil
    @objc dynamic var author: String! = nil
    @objc dynamic var authorName: String! = nil
    @objc dynamic var authorSurname: String! = nil
    @objc dynamic var commentPhoto: String! = nil
}
