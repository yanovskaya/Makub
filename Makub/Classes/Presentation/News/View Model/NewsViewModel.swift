//
//  NewsViewModel.swift
//  Makub
//
//  Created by Елена Яновская on 25.03.2018.
//  Copyright © 2018 Elena Yanovskaya. All rights reserved.
//

import Foundation

final class NewsViewModel {
    
    // MARK: - Constants
    
    private enum Constants {
        static let baseURL = "https://makub.ru"
    }
    
    // MARK: - Public Properties
    
    let text: String
    let fullName: String!
    let imageURL: String!
    let photoURL: String!
    
    // MARK: - Initialization
    
    init(_ news: News) {
        self.text = news.text
        
        if let name = news.name,
            let surname = news.surname {
            self.fullName = name + " " + surname
        } else {
            self.fullName = nil
        }
        if let photo = news.photo, photo != "" {
            self.photoURL = Constants.baseURL + photo
        } else {
            self.photoURL = nil
        }
        
        if let image = news.image, image != "" {
            self.imageURL = Constants.baseURL + image
        } else {
            self.imageURL = nil
        }
    }
}
