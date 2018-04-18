//
//  TournamentViewModel.swift
//  Makub
//
//  Created by Елена Яновская on 18.04.2018.
//  Copyright © 2018 Elena Yanovskaya. All rights reserved.
//

import Foundation

final class TournamentViewModel {
    
    // MARK: - Public Properties
    
    let name: String
    let description: String?
    let clubId: String
    let place: String
    let date: String
    let period: TimePeriod
    let status: String
    let type: String
    
    var club: String!
    
    // MARK: - Initialization
    
    init(_ tournament: Tournament) {
        if tournament.smalldesc != "" {
            name = tournament.name.capitalizeFirstLetter()
            description = tournament.smalldesc.capitalizeFirstLetter()
        } else {
            name = tournament.name.capitalizeFirstLetter()
            description = nil
        }
        clubId = tournament.club
        place = tournament.place
        status = tournament.status.getStatus()
        type = tournament.type.getType()
        if let date = tournament.date.dateConverter() {
            (self.date, self.period) = date
        } else {
            date = ""
            period = .past
        }
    }
    
}
