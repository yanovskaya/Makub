//
//  ClubViewModel.swift
//  Makub
//
//  Created by Елена Яновская on 14.04.2018.
//  Copyright © 2018 Elena Yanovskaya. All rights reserved.
//

import Foundation

final class ClubViewModel {
    
    // MARK: - Public Properties
    
    let id: String
    let name: String
    
    // MARK: - Initialization
    
    init(_ club: Club) {
        self.id = club.id
        self.name = club.name
    }
}
