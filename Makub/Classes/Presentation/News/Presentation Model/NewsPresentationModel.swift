//
//  NewsPresentationModel.swift
//  Makub
//
//  Created by Елена Яновская on 24.03.2018.
//  Copyright © 2018 Elena Yanovskaya. All rights reserved.
//

import Foundation
import UIKit

final class NewsPresentationModel: PresentationModel {
    
    // MARK: - Public Properties
    
    var userViewModel: UserViewModel!
    var newsViewModels = [NewsViewModel]()
    
    // MARK: - Private Properties
    
    private let userService = ServiceLayer.shared.userService
    private let newsService = ServiceLayer.shared.newsService
    
    private var userCacheIsObtained = false

    private let group = DispatchGroup()
    private var error: Int!
    
    // MARK: - Public Methods
    
    func obtainNewsWithUser() {
        group.enter()
        obtainUserCache()
        if !userCacheIsObtained { state = .loading }
        userService.obtainUserInfo(useCache: true) { result in
            switch result {
            case .serviceSuccess(let model):
                guard let model = model else { return }
                self.userViewModel = UserViewModel(model)
                self.group.leave()
            case .serviceFailure(let error):
                self.error = error.code
                self.group.leave()
            }
        }
        
        group.enter()
        state = .loading
        newsService.obtainNews(useCache: true) { result in
            switch result {
            case .serviceSuccess(let model):
                guard let model = model else { return }
                self.newsViewModels = model.news.compactMap { NewsViewModel($0) }
                self.group.leave()
            case .serviceFailure(let error):
                self.error = error.code
                self.group.leave()
            }
        }
        
        group.notify(queue: DispatchQueue.main) {
            if self.error != nil {
                self.state = .error(code: self.error)
            } else {
                self.state = .rich
            }
        }
    }
    
    func refreshNewsWithUser() {
        group.enter()
        userService.obtainUserInfo(useCache: false) { result in
            switch result {
            case .serviceSuccess(let model):
                guard let model = model else { return }
                self.userViewModel = UserViewModel(model)
                self.group.leave()
            case .serviceFailure:
                self.group.leave()
            }
        }
        
        group.enter()
        newsService.obtainNews(useCache: false) { result in
            switch result {
            case .serviceSuccess(let model):
                guard let model = model else { return }
                self.newsViewModels = model.news.compactMap { NewsViewModel($0) }
                self.group.leave()
            case .serviceFailure:
                self.state = .error(code: 1)
                self.group.leave()
            }
        }
        
        group.notify(queue: DispatchQueue.main) {
            if self.error == nil {
                self.state = .rich
            }
        }
    }
    
    func obtainOnlyNews() {
        newsService.obtainNews(useCache: false) { result in
            switch result {
            case .serviceSuccess(let model):
                guard let model = model else { return }
                self.newsViewModels = model.news.compactMap { NewsViewModel($0) }
                self.state = .rich
            case .serviceFailure:
                self.state = .error(code: 1)
            }
        }
    }

    
    func deleteNews(id: Int) {
        state = .loading
        newsService.deleteNews(id: id) { result in
            switch result {
            case .serviceSuccess:
                self.obtainOnlyNews()
            case .serviceFailure(let error):
                self.state = .error(code: error.code)
            }
        }
    }
    
    // MARK: - Private Methods
    
    private func obtainUserCache() {
        userService.obtainRealmCache(error: nil) { result in
            switch result {
            case .serviceSuccess(let model):
                guard let model = model else { return }
                self.userViewModel = UserViewModel(model)
                self.state = .rich
                self.userCacheIsObtained = true
            case .serviceFailure:
                break
            }
        }
    }
    
}
