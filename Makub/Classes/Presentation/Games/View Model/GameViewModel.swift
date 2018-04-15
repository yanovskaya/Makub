//
//  GameViewModel.swift
//  Makub
//
//  Created by Елена Яновская on 02.04.2018.
//  Copyright © 2018 Elena Yanovskaya. All rights reserved.
//

import Foundation

final class GameViewModel {
    
    // MARK: - Constants
    
    private enum Constants {
        static let baseURL = "https://makub.ru"
        static let classicType = "Классика"
        static let quickType = "Быстрый"
        static let quichBPType = "Быстрый БП"
    }
    
    // MARK: - Public Properties
    
    let score1: String
    let score2: String
    var type: String
    //let stage: String
    let clubId: String
    let video: String!
    let player1: String
    let player2: String
    let photo1URL: String!
    let photo2URL: String!
    let playerTime: String
    
    var club: String!
    //let comments: String
    
    // MARK: - Initialization
    
    init(_ games: Game) {
        self.score1 = games.score1
        self.score2 = games.score2
        self.clubId = games.clubId
        self.player1 = games.name1 + " " + games.surname1
        self.player2 = games.name2 + " " + games.surname2
        self.playerTime = games.playTime
        
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
                self.type = Constants.classicType
            case 2:
                self.type = Constants.quickType
            case 3:
                self.type = Constants.quichBPType
            default:
                self.type = ""
            }
        } else {
            self.type = ""
        }
    }
    
}
