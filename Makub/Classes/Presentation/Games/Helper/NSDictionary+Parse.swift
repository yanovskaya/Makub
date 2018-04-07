//
//  NSDictionary+Parse.swift
//  Makub
//
//  Created by Елена Яновская on 07.04.2018.
//  Copyright © 2018 Elena Yanovskaya. All rights reserved.
//

import Foundation

extension NSDictionary {
    func parse<T>(_ key: String) -> T {
        return self.object(forKey: key) as! T
    }
}
