//
//  Filter.swift
//  Makub
//
//  Created by Елена Яновская on 08.04.2018.
//  Copyright © 2018 Elena Yanovskaya. All rights reserved.
//

import Foundation

struct Filter {
    
    // MARK: - Constants
    
    private struct Keys {
        static var nameKey = "name"
        static var optionsKey = "options"
    }
    
    // MARK: - Public Properties
    
    let name: String
    let options: [String]
    
    // MARK: - Initialization
    
    init(info: NSDictionary) {
        name = info.parse(Keys.nameKey)
        options = info.parse(Keys.optionsKey)
    }
}
