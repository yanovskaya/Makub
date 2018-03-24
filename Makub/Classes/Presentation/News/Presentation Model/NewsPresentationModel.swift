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
    
    var viewModel = TabBarController.userViewModel {
        didSet {
            TabBarController.userViewModel = viewModel
        }
    }
    
    // MARK: - Private Properties
    
    private let userService = ServiceLayer.shared.userService
    private var cacheIsShown = false

    private let group = DispatchGroup()
    
    private var error: Int!
    
    // MARK: - Public Methods
    
    func obtainNews(completion: @escaping () -> Void) {
        showRealmCache()
        if !cacheIsShown { state = .loading }
//        if viewModel == nil {
//            state = .loading
//            group.enter()
//            userService.obtainUserInfo { result in
//                switch result {
//                case .serviceSuccess(let model):
//                    // let model = User(error: 0, photo: nil)
//                    guard let model = model else { return }
//                    TabBarController.userViewModel = UserViewModel(model)
//                    self.viewModel = UserViewModel(model)
//                    self.group.leave()
//                case .serviceFailure:
//                    print("leave")
//                    self.group.leave()
//                }
//            }
//        }
        group.enter()
        userService.obtainUserInfo { result in
            switch result {
            case .serviceSuccess(let model):
                guard let model = model else { return }
                self.viewModel = UserViewModel(model)
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
    
    private func showRealmCache() {
        userService.obtainRealmCache(error: nil) { [weak self] result in
            switch result {
            case .serviceSuccess(let model):
                guard let model = model else { return }
                self?.viewModel = UserViewModel(model)
                self?.state = .rich
                self?.cacheIsShown = true
            case .serviceFailure:
                break
            }
        }
    }

    
}
