//
//  TournamentPresentationModel.swift
//  Makub
//
//  Created by Елена Яновская on 18.04.2018.
//  Copyright © 2018 Elena Yanovskaya. All rights reserved.
//

import Foundation
import UIKit

final class TournamentsPresentationModel: PresentationModel {
    
    // MARK: - Constants
    
    private enum Constants {
        static let interClub = "Межклубный"
    }
    
    // MARK: - Public Properties
    
    var tournamentsViewModels = [TournamentViewModel]()
    var clubViewModels = [ClubViewModel]()
    
    var filterParameters = [String: [String]]()
    
    var chosenOptions = [IndexPath]()
    
    // MARK: - Private Properties
    
    private let tournamentsService = ServiceLayer.shared.tournamentsService
    private let clubsService = ServiceLayer.shared.clubsService
    
    private var fromIndex = 1
    private let count = 50
    
    private var clubsCacheIsObtained = false
    
    // MARK: - Public Methods
    
    func obtainTournamentsWithClubs() {
        state = .loading
        tournamentsService.obtainTournaments(useCache: true, from: fromIndex, count: count) { result in
            switch result {
            case .serviceSuccess(let model):
                guard let model = model else { return }
                self.tournamentsViewModels = model.tournaments.compactMap { TournamentViewModel($0) }
                self.obtainClubs()
            case .serviceFailure(let error):
                self.state = .error(code: error.code)
            }
        }
    }
    
    func refreshTournaments() {
        tournamentsService.obtainTournaments(useCache: false, from: fromIndex, count: count) { result in
            switch result {
            case .serviceSuccess(let model):
                guard let model = model else { return }
                self.tournamentsViewModels = model.tournaments.compactMap { TournamentViewModel($0) }
                self.configureClubName()
                self.state = .rich
            case .serviceFailure:
                self.state = .error(code: 1)
            }
        }
    }
    
    // MARK: - Private Methods
    
    private func obtainClubs(completion: (() -> Void)? = nil) {
        obtainClubsCache()
        if !clubsCacheIsObtained { state = .loading }
        clubsService.obtainClubs(useCache: true) { result in
            switch result {
            case .serviceSuccess(let model):
                guard let model = model else { return }
                self.clubViewModels = model.clubs.compactMap { ClubViewModel($0) }
                self.configureClubName()
                self.state = .rich
                completion?()
            case .serviceFailure(let error):
                self.state = .error(code: error.code)
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
                self.state = .rich
                self.clubsCacheIsObtained = true
            case .serviceFailure:
                break
            }
        }
    }
    
    private func configureClubName() {
        for tournamentViewModels in self.tournamentsViewModels {
            for clubViewModel in self.clubViewModels where tournamentViewModels.clubId == clubViewModel.id {
                tournamentViewModels.club = clubViewModel.name
            }
            if tournamentViewModels.clubId == "0" {
                tournamentViewModels.club = Constants.interClub
            }
        }
    }
}
