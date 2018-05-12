//
//  CommentViewModel.swift
//  Makub
//
//  Created by Елена Яновская on 15.04.2018.
//  Copyright © 2018 Elena Yanovskaya. All rights reserved.
//

import Foundation

final class CommentViewModel {
    
    private enum Constants {
        static let baseURL = "https://makub.ru"
    }
    
    // MARK: - Public Properties
    
    let comment: String
    let author: String
    let photoURL: String!
    let time: String
    let playerId: String
    let gameId: String
    
    // MARK: - Initialization
    
    init(_ comment: Comment) {
        self.comment = comment.comment.removeTags()
        self.playerId = comment.playerId
        self.gameId = comment.gameId
        self.author = comment.name + " " + comment.surname
        
        if let photo = comment.photo, photo != "" {
            self.photoURL = (Constants.baseURL + photo).encodeInURL()
        } else {
            self.photoURL = nil
        }
        
        if let time = comment.time.timeConverter() {
            self.time = time
        } else {
            self.time = ""
        }
    }
    
    init(_ comment: UserComment) {
        self.comment = comment.comment.removeTags()
        self.playerId = comment.author
        self.gameId = comment.game
        self.author = comment.authorName + " " + comment.authorSurname
        
        if let photo = comment.commentPhoto, photo != "" {
            self.photoURL = (Constants.baseURL + photo).encodeInURL()
        } else {
            self.photoURL = nil
        }
        
        if let time = comment.commentTime.timeConverter() {
            self.time = time
        } else {
            self.time = ""
        }
    }
    
}
