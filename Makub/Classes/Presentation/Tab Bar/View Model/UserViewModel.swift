//
//  UserViewModel.swift
//  Makub
//
//  Created by Елена Яновская on 24.03.2018.
//  Copyright © 2018 Elena Yanovskaya. All rights reserved.
//

import Foundation

struct UserViewModel {
    
    // MARK: - Constants
    
    private enum Constants {
        static let baseURL = "https://makub.ru"
    }
    
    // MARK: - Public Properties
    
    let photoURL: String!
    let id: String
    
    // MARK: - Initialization
    
    init(_ user: User) {
        self.id = user.id
        guard let photo = user.photo, photo != "" else {
            self.photoURL = nil
            return
        }
        self.photoURL = Constants.baseURL + photo
    }
}
