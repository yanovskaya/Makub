//
//  GamesViewModel.swift
//  Makub
//
//  Created by Елена Яновская on 02.04.2018.
//  Copyright © 2018 Elena Yanovskaya. All rights reserved.
//

import Foundation

final class GamesViewModel {
    
    // MARK: - Constants
    
    private enum Constants {
        static let baseURL = "https://makub.ru"
    }
    
    // MARK: - Public Properties
    
    let score1: String
    let score2: String
    let type: String
    //let stage: String
    //let clubId: String
    let video: String!
    let name1: String
    let surname1: String
    let photo1URL: String!
    let name2: String
    let surname2: String
    let photo2URL: String!
    //let comments: String
    
    // MARK: - Initialization
    
    init(_ games: Games) {
        
        if let type = games.type {
            self.type = obtainType(for: type)
        } else {
            self.type = ""
        }
        
        if let score1 = games.score1 {
            self.score1 = score1
        } else {
            self.score1 = ""
        }
        
        if let score2 = games.score2 {
            self.score2 = score2
        } else {
            self.score2 = ""
        }
        
        if let name1 = games.name1 {
            self.name1 = name1
        } else {
            self.name1 = ""
        }
        
        if let name2 = games.name2 {
            self.name2 = name2
        } else {
            self.name2 = ""
        }
        
        if let surname1 = games.surname1 {
            self.surname1 = surname1
        } else {
            self.surname1 = ""
        }
        
        if let surname2 = games.surname2 {
            self.surname2 = surname2
        } else {
            self.surname2 = ""
        }
        
        if let photo1 = games.photo1, photo1 != "" {
            self.photo1URL = Constants.baseURL + photo1
        } else {
            self.photo1URL = nil
        }
        
        if let photo2 = games.photo2, photo2 != "" {
            self.photo2URL = Constants.baseURL + photo2
        } else {
            self.photo2URL = nil
        }
        
        if let video = games.video, video != "" {
            self.video = video
        } else {
            self.video = nil
        }
    }
    
    private func obtainType(for id: String) -> String {
        guard let id = Int(id) else { return "" }
        switch id {
        case 1:
            return "Классика"
        case 2:
            return "Быстрый"
        case 3:
            return "Быстрый БП"
        default:
            return ""
        }
    }
}
