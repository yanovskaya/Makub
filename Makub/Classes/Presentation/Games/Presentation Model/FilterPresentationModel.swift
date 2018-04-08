//
//  FilterOptionsParser.swift
//  Makub
//
//  Created by Елена Яновская on 07.04.2018.
//  Copyright © 2018 Elena Yanovskaya. All rights reserved.
//

import Foundation

final class FilterPresentationModel {
    
    var viewModels: [FilterViewModel]!
    
    init() {
        obtainFilterOptions()
    }
    
    private func obtainFilterOptions() {
        var model = [Filter]()
        let array = NSArray(contentsOfFile: Bundle.main.path(forResource: "FilterOptions", ofType: "plist")!)!
        
        for dictionary in array as! [NSDictionary] {
            let entity = Filter(info: dictionary)
            model.append(entity)
        }
        
        let optionsDictionary: NSDictionary = ["name": "Клуб", "options": ["Stylery", "Your Mom", "", "", "", ""]]
        let optionsEntity = Filter(info: optionsDictionary)
        model.append(optionsEntity)
        viewModels = model.compactMap { FilterViewModel($0) }
    }
}
