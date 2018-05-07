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
    let place: String?
    let date: String
    let period: TimePeriod
    let status: String
    let type: String
    
    // MARK: - Initialization
    
    init(_ tournament: Tournament) {
        status = tournament.status.getStatus()
        type = tournament.type.getType()
        
        if let description = tournament.smalldesc, description != "" {
            name = tournament.name.capitalizeFirstLetter()
            self.description = description.capitalizeFirstLetter()
        } else {
            name = tournament.name.capitalizeFirstLetter()
            description = nil
        }
        if let place = tournament.place, place != "" {
            self.place = place
        } else {
            self.place = nil
        }
        if let date = tournament.date.dateConverter() {
            (self.date, self.period) = date
        } else {
            date = ""
            period = .past
        }
    }
    
    // Моковый инициализатор.
    init(desc: Bool, date: Bool) {
        name = "Турнир года"
        var dd: String
        if Int(arc4random_uniform(UInt32(100))) < 30 {
            dd = "2018-04-18"
        } else if Int(arc4random_uniform(UInt32(100))) < 60 {
             dd = "2017-04-21"
        } else {
            dd = "2018-04-20"
        }
        if let date = dd.dateConverter() {
            (self.date, self.period) = date
        } else {
            self.date = ""
            period = .past
        }
        if date {
            self.place = "Турнир года турнир турнир рутнри турна"
        } else {
            self.place = nil
        }
        if desc {
            self.description = "где-то правоы ваполыао оавлпта оавлпта аоаыялв"
        } else {
            self.description = nil
        }
        type = "1".getType()
        status = "2".getStatus()
    }
}
