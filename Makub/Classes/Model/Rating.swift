//
//  Rating.swift
//  Makub
//
//  Created by Елена Яновская on 19.04.2018.
//  Copyright © 2018 Elena Yanovskaya. All rights reserved.
//

import Foundation
import RealmSwift

final class Rating: Object, Decodable {
    
    @objc dynamic var id: String! = nil
    @objc dynamic var name: String! = nil
    @objc dynamic var surname: String! = nil
    @objc dynamic var club: String! = nil
    @objc dynamic var ratingOfPlayer: String! = nil
    @objc dynamic var ratingFast: String! = nil
    @objc dynamic var ratingVeryFast: String! = nil
    @objc dynamic var ratingClassic: String! = nil
    @objc dynamic var photo: String! = nil
}
