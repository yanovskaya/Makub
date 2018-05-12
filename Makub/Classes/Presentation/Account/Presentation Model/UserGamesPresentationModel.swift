//
//  UserGamesPresentationModel.swift
//  Makub
//
//  Created by Елена Яновская on 24.04.2018.
//  Copyright © 2018 Elena Yanovskaya. All rights reserved.
//

import Foundation
import UIKit

final class UserGamesPresentationModel: PresentationModel {
    
    // MARK: - Public Properties
    
    var userViewModel: UserViewModel!
    var gamesViewModels = [UserGameViewModel]()
     var title: String!
    
    // MARK: - Private Properties
    
    private let accountService = ServiceLayer.shared.accountService
    private let fromCount = 0
    private var toCount: Int {
        return userViewModel.games
    }
    
    // MARK: - Public Methods
    
    func obtainAllGames() {
        state = .loading
        accountService.obtainUserGames(from: fromCount, to: toCount, useCache: true) { result in
            switch result {
            case .serviceSuccess(let model):
                guard let model = model else { return }
                self.gamesViewModels = model.games.compactMap { UserGameViewModel($0) }
                self.state = .rich
            case .serviceFailure(let error):
                self.state = .error(code: error.code)
            }
        }
    }
    
    func refreshAllGames() {
        state = .loading
        accountService.obtainUserGames(from: fromCount, to: toCount, useCache: false) { result in
            switch result {
            case .serviceSuccess(let model):
                guard let model = model else { return }
                self.gamesViewModels = model.games.compactMap { UserGameViewModel($0) }
                self.state = .rich
            case .serviceFailure(let error):
                self.state = .error(code: error.code)
            }
        }
    }
}
