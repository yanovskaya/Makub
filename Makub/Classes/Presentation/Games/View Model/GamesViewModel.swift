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
    var type: String
    //let stage: String
    //let clubId: String
    let video: String!
    let player1: String
    let player2: String
    let photo1URL: String!
    let photo2URL: String!
    //let comments: String
    
    // MARK: - Initialization
    
    init(_ games: Games) {
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
        
        if let name1 = games.name1,
            let surname1 = games.surname1 {
            self.player1 = name1 + " " + surname1
        } else {
            self.player1 = ""
        }
        
        if let name2 = games.name2,
            let surname2 = games.surname2 {
            self.player2 = name2 + " " + surname2
        } else {
            self.player2 = ""
        }
        
        if let photo1 = games.photo1, photo1 != "" {
            self.photo1URL = (Constants.baseURL + photo1).removeSpacesInURL()
        } else {
            self.photo1URL = nil
        }
        
        if let photo2 = games.photo2, photo2 != "" {
            self.photo2URL = (Constants.baseURL + photo2).removeSpacesInURL()
        } else {
            self.photo2URL = nil
        }
        
        if let video = games.video, video != "" {
            self.video = video
        } else {
            self.video = nil
        }
        
        if let type = games.type {
            guard let typeId = Int(type) else {
                self.type = ""
                return
            }
            switch typeId {
            case 1:
                self.type =  "Классика"
            case 2:
                self.type =  "Быстрый"
            case 3:
                self.type =  "Быстрый БП"
            default:
                self.type = ""
            }
        } else {
            self.type = ""
        }
    }
    
}
