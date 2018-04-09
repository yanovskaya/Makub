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
    
    var viewModels = [GameViewModel]()
    
    // MARK: - Private Properties
    
    private let gamesService = ServiceLayer.shared.gamesService
    
    private var fromIndex = 1
    private var toIndex = 80
    private let count = 80
    
    // MARK: - Public Methods
    
    func obtainGames() {
        state = .loading
        gamesService.obtainGames(from: fromIndex, to: count, useCache: true) { result in
            switch result {
            case .serviceSuccess(let model):
                guard let model = model else { return }
                self.viewModels = model.games.compactMap { GameViewModel($0) }
                self.state = .rich
            case .serviceFailure(let error):
                self.state = .error(code: error.code)
            }
        }
    }
    
    func obtainMoreGames() {
        let count = 20
        fromIndex = toIndex + 1
        toIndex += count
        gamesService.obtainGames(from: fromIndex, to: count, useCache: false) { result in
            switch result {
            case .serviceSuccess(let model):
                guard let model = model else { return }
                let moreViewModels = model.games.compactMap { GameViewModel($0) }
                self.viewModels += moreViewModels
                self.state = .rich
            case .serviceFailure:
                self.state = .error(code: 1)
            }
        }
        
    }
    
    func refreshGames() {
        fromIndex = 1
        toIndex = 100
        gamesService.obtainGames(from: fromIndex, to: count, useCache: false) { result in
            switch result {
            case .serviceSuccess(let model):
                guard let model = model else { return }
                self.viewModels = model.games.compactMap { GameViewModel($0) }
                self.state = .rich
            case .serviceFailure:
                self.state = .error(code: 1)
            }
        }
    }
    
    func filterAllGamesViewModels(viewModels: [GameViewModel], parameters: [String: [String]]) {
        state = .loading
        self.viewModels = viewModels
        for parameter in parameters {
            self.viewModels = self.viewModels.filter { game in
                if parameter.key == "Тип" {
                    for value in parameter.value {
                        return game.type.lowercased() == value.lowercased()
                    }
                }
                return false
            }
        }
        state = .rich
    }
}
