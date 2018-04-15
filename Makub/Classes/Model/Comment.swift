//
//  Comment.swift
//  Makub
//
//  Created by Елена Яновская on 15.04.2018.
//  Copyright © 2018 Elena Yanovskaya. All rights reserved.
//

import Foundation
import RealmSwift

final class Comment: Object, Decodable {
    
    @objc dynamic var id: String! = nil
    @objc dynamic var comment: String! = nil
    @objc dynamic var player_id: String! = nil
    @objc dynamic var time: String! = nil
    @objc dynamic var name: String! = nil
    @objc dynamic var surname: String! = nil
    @objc dynamic var photo: String! = nil
}
