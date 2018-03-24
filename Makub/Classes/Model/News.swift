//
//  News.swift
//  Makub
//
//  Created by Елена Яновская on 24.03.2018.
//  Copyright © 2018 Elena Yanovskaya. All rights reserved.
//

import Foundation
import RealmSwift

final class News: Object, Decodable {
    
    @objc dynamic var text: String = ""
    @objc dynamic var tag: String = ""
    @objc dynamic var date: String = ""
    @objc dynamic var image: String = ""
    @objc dynamic var name: String! = nil
    @objc dynamic var surname: String! = nil
    @objc dynamic var photo: String! = nil
}
