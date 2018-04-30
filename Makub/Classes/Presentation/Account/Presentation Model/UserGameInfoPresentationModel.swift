//
//  UserGameInfoPresentationModel.swift
//  Makub
//
//  Created by Елена Яновская on 30.04.2018.
//  Copyright © 2018 Elena Yanovskaya. All rights reserved.
//

import Foundation

final class UserGameInfoPresentationModel: PresentationModel {
    
    // MARK: - Constants
    
    private enum Constants {
        static let friendGame = "Товарищеский матч"
        static let interClub = "Межклубный"
    }
    
    // MARK: - Public Properties
    
    var gameId: String!
    var gameInfoViewModel: GameInfoViewModel!
    var tournamentViewModel: TournamentForGameViewModel!
    var commentViewModels = [CommentViewModel]()
    var clubViewModels = [ClubViewModel]()
    var userViewModel: UserViewModel!
    
    // MARK: - Private Properties
    
    private let gameInfoService = ServiceLayer.shared.gameInfoService
    private let userService = ServiceLayer.shared.userService
    private let clubsService = ServiceLayer.shared.clubsService
    
    private let group = DispatchGroup()
    private var error: Int!
    
    private var clubsCacheIsObtained = false
    
    // MARK: - Public Methods
    
    func obtainGame() {
        error = nil
        
        group.enter()
        obtainGameInfo()
        
        group.enter()
        obtainComments()
        
        group.notify(queue: DispatchQueue.main) {
            if self.error != nil {
                self.state = .error(code: self.error)
            } else {
                self.state = .rich
            }
        }
    }
    
    func obtainOnlyComments() {
        state = .loading
        guard let gameId = Int(gameId) else { return }
        gameInfoService.obtainComments(gameId: gameId) { result in
            switch result {
            case .serviceSuccess(let model):
                guard let model = model else { return }
                self.commentViewModels = model.comments.compactMap { CommentViewModel($0) }
                self.state = .rich
            case .serviceFailure(let error):
                self.state = .error(code: error.code)
            }
        }
    }
    
    
    // MARK: - Private Methods
    
    private func obtainUserInfo() {
        state = .loading
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
    }
    
    private func obtainGameInfo() {
        guard let gameId = Int(gameId) else { return }
        gameInfoService.obtainGameInfo(gameId: gameId) { result in
            switch result {
            case .serviceSuccess(let model):
                guard let model = model else { return }
                self.gameInfoViewModel = GameInfoViewModel(model)
                self.obtainClubs()
                if self.gameInfoViewModel.stage != "0" {
                    self.group.enter()
                    self.obtainTournament()
                } else {
                    self.tournamentViewModel = TournamentForGameViewModel(title: Constants.friendGame)
                }
            case .serviceFailure(let error):
                self.error = error.code
                self.group.leave()
            }
        }
    }
    
    private func obtainTournament() {
        state = .loading
        guard let stage = Int(gameInfoViewModel.stage) else { return }
        gameInfoService.obtainTournament(stage: stage) { result in
            switch result {
            case .serviceSuccess(let model):
                guard let model = model else { return }
                self.tournamentViewModel = TournamentForGameViewModel(model.tournament)
                self.group.leave()
            case .serviceFailure(let error):
                self.error = error.code
                self.group.leave()
            }
        }
    }
    
    private func obtainComments() {
        state = .loading
        guard let gameId = Int(gameId) else { return }
        gameInfoService.obtainComments(gameId: gameId) { result in
            switch result {
            case .serviceSuccess(let model):
                guard let model = model else { return }
                self.commentViewModels = model.comments.compactMap { CommentViewModel($0) }
                self.group.leave()
            case .serviceFailure:
                self.group.leave()
            }
        }
    }
    
    private func obtainClubs() {
        obtainClubsCache()
        if !clubsCacheIsObtained { state = .loading }
        clubsService.obtainClubs(useCache: true) { result in
            switch result {
            case .serviceSuccess(let model):
                guard let model = model else { return }
                self.clubViewModels = model.clubs.compactMap { ClubViewModel($0) }
                self.group.leave()
                self.configureClubName()
            case .serviceFailure(let error):
                self.error = error.code
                self.group.leave()
            }
        }
    }
    
    private func obtainClubsCache() {
        clubsService.obtainClubsRealmCache(error: nil) { result in
            switch result {
            case .serviceSuccess(let model):
                guard let model = model else { return }
                self.clubViewModels = model.clubs.compactMap { ClubViewModel($0) }
                self.configureClubName()
                self.clubsCacheIsObtained = true
            case .serviceFailure:
                break
            }
        }
    }
    
    private func configureClubName() {
        for clubViewModel in self.clubViewModels where clubViewModel.id == gameInfoViewModel.clubId {
            gameInfoViewModel.club = clubViewModel.name
        }
        if gameInfoViewModel.clubId == "0" {
            gameInfoViewModel.club = Constants.interClub
        }
    }
}
