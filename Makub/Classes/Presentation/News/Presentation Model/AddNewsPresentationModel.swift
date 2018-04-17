//
//  AddNewsPresentationModel.swift
//  Makub
//
//  Created by Елена Яновская on 17.04.2018.
//  Copyright © 2018 Elena Yanovskaya. All rights reserved.
//

import Foundation
import UIKit

final class AddNewsPresentationModel: PresentationModel {
    
    // MARK: - Public Properties
    
    var userViewModel: UserViewModel!
    
    // MARK: - Private Properties
    
    private let newsService = ServiceLayer.shared.newsService
    
    // MARK: - Public Methods
    
    func addNews(title: String, text: String) {
        state = .loading
        newsService.addNews(title: title, text: text) { result in
            switch result {
            case .serviceSuccess:
                self.state = .rich
            case .serviceFailure(let error):
                self.state = .error(code: error.code)
            }
        }
    }
    
    func addNewsWithImage(title: String, text: String, image: UIImage) {
        state = .loading
        newsService.addNewsWithImage(title: title, text: text, image: image) { result in
            switch result {
            case .serviceSuccess:
                self.state = .rich
            case .serviceFailure(let error):
                self.state = .error(code: error.code)
            }
        }
    }
}
