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
    
    let id: String
    let score1: String
    let score2: String
    let stage: String
    let clubId: String
    let video: String!
    let player1: String
    let player2: String
    let photo1URL: String!
    let photo2URL: String!
    let playerTime: String
    let comments: String
    
    var type: String
    var club: String!
    
    // MARK: - Initialization
    
    init(_ game: Game) {
        self.id = game.id
        self.score1 = game.score1
        self.score2 = game.score2
        self.clubId = game.clubId
        self.player1 = game.name1 + " " + game.surname1
        self.player2 = game.name2 + " " + game.surname2
        
        self.stage = game.stage
        self.comments = game.comments
        
        if let time = game.playTime.timeConverter() {
            self.playerTime = time
        } else {
            self.playerTime = ""
        }
        if let photo1 = game.photo1, photo1 != "" {
            self.photo1URL = (Constants.baseURL + photo1).removeSpacesInURL()
        } else {
            self.photo1URL = nil
        }
        
        if let photo2 = game.photo2, photo2 != "" {
            self.photo2URL = (Constants.baseURL + photo2).removeSpacesInURL()
        } else {
            self.photo2URL = nil
        }
        
        if let video = game.video, video != "", video.count < 20 {
            self.video = video
        } else {
            self.video = nil
        }
        
        if let type = game.type {
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
