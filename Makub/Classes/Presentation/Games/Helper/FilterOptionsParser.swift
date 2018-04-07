//
//  FilterOptionsParser.swift
//  Makub
//
//  Created by Елена Яновская on 07.04.2018.
//  Copyright © 2018 Elena Yanovskaya. All rights reserved.
//

import Foundation

final class FilterOption {
    private struct Keys {
        static var nameKey = "name"
        static var optionsKey = "options"
    }
    
    var name: String
    var options: [String] = []
    
    init(info: NSDictionary) {
        name = info.parse(Keys.nameKey)
        options = info.parse(Keys.optionsKey)
    }
}

class FilterOptionsParser {
    static var filterOptions: [FilterOption] = FilterOptionsParser.obtainFilterOptions()
    
    private class func obtainFilterOptions() -> [FilterOption] {
        var result: [FilterOption] = []
        let array = NSArray(contentsOfFile: Bundle.main.path(forResource: "FilterOptions", ofType: "plist")!)!
        
        for dictionary in array as! [NSDictionary] {
            let entity = FilterOption(info: dictionary)
            result.append(entity)
        }
        
        let optionsDictionary: NSDictionary = ["name": "Клуб", "options": ["Stylery", "Your Mom"]]
        let optionsEntity = FilterOption(info: optionsDictionary)
        result.append(optionsEntity)
        return result
    }
}
