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
    let player: String
    let photoURL: String!
    let time: String
    
    // MARK: - Initialization
    
    init(_ comment: Comment) {
        self.comment = comment.comment
        self.player = comment.name + " " + comment.surname
        
        if let photo = comment.photo, photo != "" {
            self.photoURL = (Constants.baseURL + photo).removeSpacesInURL()
        } else {
            self.photoURL = nil
        }
        
        if let time = comment.time.timeConverter() {
            self.time = time
        } else {
            self.time = ""
        }
    }
    
}
