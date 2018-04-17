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
    
    // MARK: - Constants
    
    private enum Constants {
        static let typeKey = "Тип"
        static let clubKey = "Клуб"
        
        static let videoKey = "Видео"
        static let trueVideo = "С видео"
        static let falseVideo = "Без видео"
        
        static let tournamentKey = "Турнир"
        static let friendGame = "Товарищеская игра"
        static let interClub = "Межклубный"
        static let tournament = "Турнир"
    }
    
    // MARK: - Public Properties
    
    var gamesViewModels = [GameViewModel]()
    var clubViewModels = [ClubViewModel]()
    
    var filterParameters = [String: [String]]()
    
    var chosenOptions = [IndexPath]()
    
    // MARK: - Private Properties
    
    private let gamesService = ServiceLayer.shared.gamesService
    
    private var fromIndex = 1
    private var toIndex = 80
    private let count = 80
    
    private var clubsCacheIsObtained = false
    
    // MARK: - Public Methods
    
    func obtainGamesWithClubs() {
        state = .loading
        gamesService.obtainGames(from: fromIndex, to: count, useCache: true) { result in
            switch result {
            case .serviceSuccess(let model):
                guard let model = model else { return }
                self.gamesViewModels = model.games.compactMap { GameViewModel($0) }
                self.obtainClubs()
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
                self.gamesViewModels += moreViewModels
                for gameViewModel in self.gamesViewModels {
                    for clubViewModel in self.clubViewModels where gameViewModel.clubId == clubViewModel.id {
                        gameViewModel.club = clubViewModel.name
                    }
                }
                self.state = .rich
            case .serviceFailure:
                self.state = .error(code: 1)
            }
        }
        
    }
    
    func refreshGames() {
        fromIndex = 1
        toIndex = 80
        gamesService.obtainGames(from: fromIndex, to: count, useCache: false) { result in
            switch result {
            case .serviceSuccess(let model):
                guard let model = model else { return }
                self.gamesViewModels = model.games.compactMap { GameViewModel($0) }
                for gameViewModel in self.gamesViewModels {
                    for clubViewModel in self.clubViewModels where gameViewModel.clubId == clubViewModel.id {
                        gameViewModel.club = clubViewModel.name
                    }
                    if gameViewModel.clubId == "0" {
                        gameViewModel.club = Constants.interClub
                    }
                }
                self.state = .rich
            case .serviceFailure:
                self.state = .error(code: 1)
            }
        }
    }

    
    func obtainAllGames(parameters: [String: [String]]) {
        gamesService.obtainGamesCount { result in
            switch result {
            case .serviceSuccess(let model):
                self.obtainFilterGames(count: model!.count, parameters: parameters)
            case .serviceFailure(let error):
                self.state = .error(code: error.code)
            }
        }
    }
    
    func saveChosenOptions(_ options: [IndexPath]) {
        chosenOptions = options
    }
    
    // MARK: - Private Methods
    
    private func obtainFilterGames(count: Int = 2000, parameters: [String: [String]]) {
        state = .loading
        filterParameters = parameters
        gamesService.obtainGames(from: 1, to: count, useCache: true) { result in
            switch result {
            case .serviceSuccess(let model):
                guard let model = model else { return }
                self.gamesViewModels = model.games.compactMap { GameViewModel($0) }
                for gameViewModel in self.gamesViewModels {
                    for clubViewModel in self.clubViewModels where gameViewModel.clubId == clubViewModel.id {
                        gameViewModel.club = clubViewModel.name
                    }
                }
                self.filterAllGamesViewModels()
            case .serviceFailure(let error):
                self.state = .error(code: error.code)
            }
        }
    }
    
    private func filterAllGamesViewModels() {
        for parameter in filterParameters {
            self.gamesViewModels = self.gamesViewModels.filter { game in
                if parameter.key == Constants.typeKey {
                    for value in parameter.value where game.type == value {
                        return true
                    }
                } else if parameter.key == Constants.clubKey {
                    for value in parameter.value where game.club == value {
                        return true
                    }
                } else if parameter.key == Constants.videoKey {
                    for value in parameter.value {
                        if value == Constants.trueVideo,
                            game.video != nil {
                            return true
                        } else if value == Constants.falseVideo,
                            game.video == nil {
                            return true
                        }
                    }
                } else if parameter.key == Constants.tournamentKey {
                    for value in parameter.value {
                        if value == Constants.friendGame,
                            game.stage == "0" {
                            return true
                        } else if value == Constants.tournament,
                            game.stage != "0" {
                            return true
                        }
                    }
                }
                return false
            }
        }
        state = .rich
    }
    
    private func obtainClubs(completion: (() -> Void)? = nil) {
        obtainClubsCache()
        if !clubsCacheIsObtained { state = .loading }
        gamesService.obtainClubs(useCache: true) { result in
            switch result {
            case .serviceSuccess(let model):
                guard let model = model else { return }
                self.clubViewModels = model.clubs.compactMap { ClubViewModel($0) }
                for gameViewModel in self.gamesViewModels {
                    for clubViewModel in self.clubViewModels where clubViewModel.id == gameViewModel.clubId {
                        gameViewModel.club = clubViewModel.name
                    }
                    if gameViewModel.clubId == "0" {
                        gameViewModel.club = Constants.interClub
                    }
                }
                self.state = .rich
                completion?()
            case .serviceFailure(let error):
                self.state = .error(code: error.code)
            }
        }
    }
    
    private func obtainClubsCache() {
        gamesService.obtainClubsRealmCache(error: nil) { result in
            switch result {
            case .serviceSuccess(let model):
                guard let model = model else { return }
                self.clubViewModels = model.clubs.compactMap { ClubViewModel($0) }
                for gameViewModel in self.gamesViewModels {
                    for clubViewModel in self.clubViewModels where gameViewModel.clubId == clubViewModel.id {
                        gameViewModel.club = clubViewModel.name
                    }
                    if gameViewModel.clubId == "0" {
                        gameViewModel.club = Constants.interClub
                    }
                }
                self.state = .rich
                self.clubsCacheIsObtained = true
            case .serviceFailure:
                break
            }
        }
    }
    
}
