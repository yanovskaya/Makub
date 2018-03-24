//
//  NewsPresentationModel.swift
//  Makub
//
//  Created by Елена Яновская on 24.03.2018.
//  Copyright © 2018 Elena Yanovskaya. All rights reserved.
//

import Foundation

final class NewsPresentationModel: PresentationModel {
    
    // MARK: - Public Properties
    
    var tabBarViewModel = TabBarController.userViewModel {
        didSet {
            TabBarController.userViewModel = tabBarViewModel
        }
    }
    
    var newsViewModels = [NewsViewModel]()
    
    // MARK: - Private Properties
    
    private let userService = ServiceLayer.shared.userService
    private let newsService = ServiceLayer.shared.newsService
    
    private var userCacheIsObtained = false
    private var newsCacheIsObtained = false

    private let group = DispatchGroup()
    
    private var error: Int!
    
    // MARK: - Public Methods
    
    func obtainNews(completion: @escaping () -> Void) {
        group.enter()
        obtainUserCache()
        if !userCacheIsObtained { state = .loading }
        if tabBarViewModel == nil {
            userService.obtainUserInfo { result in
                switch result {
                case .serviceSuccess(let model):
                    guard let model = model else { return }
                    self.tabBarViewModel = UserViewModel(model)
                    self.group.leave()
                case .serviceFailure(let error):
                    self.error = error.code
                    self.group.leave()
                }
            }
        }
        
        group.enter()
        obtainNewsCache()
        if !newsCacheIsObtained { state = .loading }
        newsService.obtainNews { result in
            switch result {
            case .serviceSuccess(let model):
                guard let model = model else { return }
                self.newsViewModels = model.news.flatMap { NewsViewModel($0) }
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
            completion()
        }
        
    }
    
    // MARK: - Private Methods
    
    private func obtainUserCache() {
        userService.obtainRealmCache(error: nil) { [weak self] result in
            switch result {
            case .serviceSuccess(let model):
                guard let model = model else { return }
                self?.tabBarViewModel = UserViewModel(model)
                self?.state = .rich
                self?.userCacheIsObtained = true
            case .serviceFailure:
                break
            }
        }
    }
    
    private func obtainNewsCache() {
        newsService.obtainRealmCache(error: nil) { [weak self] result in
            switch result {
            case .serviceSuccess(let model):
                guard let model = model else { return }
                self?.newsViewModels = model.news.flatMap { NewsViewModel($0) }
                self?.state = .rich
                self?.newsCacheIsObtained = true
            case .serviceFailure:
                break
            }
        }
    }
    
}
