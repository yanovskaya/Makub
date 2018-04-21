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
    
    // MARK: - Initialization
    
    init(_ user: UserDecodable) {
        id = user.id
        club = user.club
        fullname = user.name + " " + user.surname
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
            photoURL = (Constants.baseURL + photo).removeSpacesInURL()
        } else {
            photoURL = nil
        }
    }
}
