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
        if tournament.smalldesc != "" {
            self.tournament = tournament.smalldesc.capitalizeFirstLetter()
            description = tournament.name.capitalizeFirstLetter()
        } else {
            self.tournament = tournament.name.capitalizeFirstLetter()
            description = nil
        }
    }
    
    init(title: String) {
        tournament = title
        description = nil
    }
    
}
