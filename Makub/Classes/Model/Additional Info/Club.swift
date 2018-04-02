//
//  Club.swift
//  Makub
//
//  Created by Елена Яновская on 02.04.2018.
//  Copyright © 2018 Elena Yanovskaya. All rights reserved.
//

import Foundation
import RealmSwift

final class Club: Object, Decodable {
    
    @objc dynamic var name: String = ""
}
