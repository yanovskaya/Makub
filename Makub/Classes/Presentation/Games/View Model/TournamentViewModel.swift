//
//  TournamentViewModel.swift
//  Makub
//
//  Created by Елена Яновская on 15.04.2018.
//  Copyright © 2018 Elena Yanovskaya. All rights reserved.
//

import Foundation

final class TournamentViewModel {
    
    // MARK: - Public Properties
    
    let tournament: String
    let description: String?
    
    // MARK: - Initialization
    
    init(_ tournament: Tournament) {
        self.tournament = tournament.smalldesc.capitalizeFirstLetter()
        self.description = tournament.name.capitalizeFirstLetter()
    }
    
    init(title: String) {
        tournament = title
        description = nil
    }
    
}
