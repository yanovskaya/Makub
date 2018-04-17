//
//  FilterViewModel.swift
//  Makub
//
//  Created by Елена Яновская on 08.04.2018.
//  Copyright © 2018 Elena Yanovskaya. All rights reserved.
//

import Foundation

final class FilterGamesViewModel {
    
    // MARK: - Public Properties
    
    let name: String
    let options: [String]
    
    // MARK: - Initialization
    
    init(_ filter: Filter) {
        name = filter.name
        options = filter.options
    }
    
}
