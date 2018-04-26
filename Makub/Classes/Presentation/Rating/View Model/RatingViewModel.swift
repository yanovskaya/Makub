//
//  RatingViewModel.swift
//  Makub
//
//  Created by Елена Яновская on 19.04.2018.
//  Copyright © 2018 Elena Yanovskaya. All rights reserved.
//

import Foundation

final class RatingViewModel {
    
    // MARK: - Constants
    
    private enum Constants {
        static let baseURL = "https://makub.ru"
    }
    
    // MARK: - Public Properties
    
    let id: String
    let fullname: String
    let club: String
    let commonRating: Int
    let fastRating: Int
    let veryFastRating: Int
    let classicRating: Int
    let photoURL: String!
    
    // MARK: - Initialization
    
    init(_ rating: Rating) {
        id = rating.id
        fullname = rating.name + " " + rating.surname
        if let club = rating.club {
            self.club = club
        } else {
            club = ""
        }
        if let commonRating = Int(rating.ratingOfPlayer) {
            self.commonRating = commonRating
        } else {
            commonRating = 0
        }
        if let fastRating = Int(rating.ratingFast) {
            self.fastRating = fastRating
        } else {
            fastRating = 0
        }
        if let veryFastRating = Int(rating.ratingVeryFast) {
            self.veryFastRating = veryFastRating
        } else {
            veryFastRating = 0
        }
        if let classicRating = Int(rating.ratingClassic) {
            self.classicRating = classicRating
        } else {
            classicRating = 0
        }
        if let photo = rating.photo, photo != "" {
            self.photoURL = (Constants.baseURL + photo).encodeInURL()
        } else {
            self.photoURL = nil
        }
    }
}
