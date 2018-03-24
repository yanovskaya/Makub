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
    
    var viewModel = TabBarController.userViewModel
    
    // MARK: - Private Properties
    
    private let userService = ServiceLayer.shared.userService
    private let group = DispatchGroup()
    
    private var error: Int!
    
    // MARK: - Public Methods
    
    func obtainNews(completion: @escaping () -> Void) {
        if viewModel == nil {
            state = .loading
            group.enter()
            userService.obtainUserInfo { result in
                switch result {
                case .serviceSuccess(let model):
                    // let model = User(error: 0, photo: nil)
                    guard let model = model else { return }
                    TabBarController.userViewModel = UserViewModel(model)
                    self.viewModel = UserViewModel(model)
                    self.group.leave()
                case .serviceFailure:
                    print("leave")
                    self.group.leave()
                }
            }
        }
        group.enter()
        userService.obtainUserInfo { result in
            switch result {
            case .serviceSuccess(let model):
                guard let model = model else { return }
                //TabBarController.userViewModel = UserViewModel(model)
                self.group.leave()
            case .serviceFailure(let error):
                self.error = error.code
                self.group.leave()
            }
        }
        
        group.notify(queue:  DispatchQueue.main) {
            if self.error != nil {
                self.state = .error(code: self.error)
            } else {
                self.state = .rich
            }
            completion()
        }
        
    }
    
}
