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
        static let defaultTitle = "Новость"
    }
    
    // MARK: - Public Properties
    
    let title: String
    let text: String
    let date: String
    let tag: String
    let fullName: String!
    let imageURL: String!
    let photoURL: String!
    
    // MARK: - Initialization
    
    init(_ news: News) {
        self.text = news.text
        self.date = news.date
        self.title = news.title
        self.tag = news.tag
        
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
