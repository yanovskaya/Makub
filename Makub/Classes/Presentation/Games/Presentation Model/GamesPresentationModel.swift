//
//  GamesPresentationModel.swift
//  Makub
//
//  Created by Елена Яновская on 02.04.2018.
//  Copyright © 2018 Elena Yanovskaya. All rights reserved.
//

import Foundation
import UIKit

final class GamesPresentationModel: PresentationModel {
    
    // MARK: - Public Properties
    
    var gamesViewModels = [GamesViewModel]()
    
    // MARK: - Private Properties
    
    private let gamesService = ServiceLayer.shared.gamesService
    private let fromIndex = 0
    private var toIndex = 100
    
    private var newsCacheIsObtained = false
    
    // MARK: - Public Methods
    
    func obtainGames() {
        state = .loading
        gamesService.obtainAllGames(from: fromIndex, to: toIndex) { result in
            switch result {
            case .serviceSuccess(let model):
                guard let model = model else { return }
                self.gamesViewModels = model.games.flatMap { GamesViewModel($0) }
            case .serviceFailure(let error):
                self.state = .error(code: error.code)
            }
        }
        
    }
    
    func refreshGames() {
        gamesService.obtainAllGames(from: fromIndex, to: toIndex) { result in
            switch result {
            case .serviceSuccess(let model):
                guard let model = model else { return }
                self.gamesViewModels = model.games.flatMap { GamesViewModel($0) }
                self.state = .rich
            case .serviceFailure:
                break
            }
        }

    }
    
}
