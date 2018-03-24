//
//  NewsViewModel.swift
//  Makub
//
//  Created by Елена Яновская on 25.03.2018.
//  Copyright © 2018 Elena Yanovskaya. All rights reserved.
//

import Foundation

final class NewsViewModel {
    
    // MARK: - Public Properties
    
    let news: News
    
    // MARK: - Initialization
    
    init(_ news: News) {
        self.news = news
    }
}
