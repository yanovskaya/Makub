//
//  UserViewModel.swift
//  Makub
//
//  Created by Елена Яновская on 24.03.2018.
//  Copyright © 2018 Elena Yanovskaya. All rights reserved.
//

import Foundation

struct UserViewModel {
    
    // MARK: - Constants
    
    private enum Constants {
        static let baseURL = "https://makub.ru"
    }
    
    // MARK: - Public Properties
    
    let photoURL: String!
    let id: String
    let fullname: String
    let club: String
    let rankClassic: String?
    let rankFast: String?
    var achievements = [String]()
    var games: Int
    var win: Int
    var lose: Int
    
    var commonPosition: String!
    var classicPosition: String!
    var fastPosition: String!
    var veryFastPosition: String!
    
    let commonRating: String
    let fastRating: String
    let veryFastRating: String
    let classicRating: String
    
    // MARK: - Initialization
    
    init(_ user: UserDecodable) {
        id = user.id
        fullname = user.name + " " + user.surname
        commonRating = user.ratingOfPlayer
        fastRating = user.ratingFast
        veryFastRating = user.ratingVeryFast
        classicRating = user.ratingClassic
        win = user.win
        lose = user.lose
        games = lose + win
        if let club = user.club {
            self.club = club
        } else {
            self.club = ""
        }
        for achievemnet in user.dost {
            achievements.append(achievemnet.name)
        }
        if let rankClassic = user.razryad, rankClassic != "" {
            self.rankClassic = rankClassic.getRomanRank()
        } else {
            rankClassic = nil
        }
        if let rankFast = user.razryadFast, rankFast != "" {
            self.rankFast = rankFast.getRomanRank()
        } else {
            rankFast = nil
        }
        if let photo = user.photo, photo != "" {
            photoURL = (Constants.baseURL + photo).encodeInURL()
        } else {
            photoURL = nil
        }
    }
}
