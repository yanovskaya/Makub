//
//  UserGameViewModel.swift
//  Makub
//
//  Created by Елена Яновская on 23.04.2018.
//  Copyright © 2018 Elena Yanovskaya. All rights reserved.
//

import Foundation

final class UserGameViewModel {
    
    // MARK: - Constants
    
    private enum Constants {
        static let baseURL = "https://makub.ru"
    }
    
    // MARK: - Public Properties
    
    let id: String
    let ourScore: String
    let hisScore: String
    let video: String!
    let player: String
    let photoURL: String!
    let comments: String
    let commentsDescription: String
    let type: String
    
    // MARK: - Initialization
    
    init(_ game: UserGame) {
        self.id = game.id
        self.ourScore = game.ourScore
        self.hisScore = game.hisScore
        self.player = game.name + " " + game.surname
        self.comments = game.comments
        self.commentsDescription = game.comments.getCommentsCount()
        
        if let photo = game.photo, photo != "" {
            self.photoURL = (Constants.baseURL + photo).encodeInURL()
        } else {
            self.photoURL = nil
        }
        
        if let video = game.video, video != "", video != "0", video.count < 20 {
            self.video = video
        } else {
            self.video = nil
        }
        
        if let type = game.gameType {
            self.type = type.getType()
        } else {
            self.type = ""
        }
    }
}
