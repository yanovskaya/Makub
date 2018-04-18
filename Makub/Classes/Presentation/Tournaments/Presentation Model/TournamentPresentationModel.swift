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
    
    // MARK: - Private Properties
    
    private let tournamentsService = ServiceLayer.shared.tournamentsService
    
    private var fromIndex = 1
    private let count = 50
    
    // MARK: - Public Methods
    
    func obtainTournamentsWithClubs() {
        state = .loading
        tournamentsService.obtainTournaments(useCache: true, from: fromIndex, count: count) { result in
            switch result {
            case .serviceSuccess(let model):
                guard let model = model else { return }
                //self.tournamentsViewModels = model.tournaments.compactMap { TournamentViewModel($0) }
                // моковый объект
                self.tournamentsViewModels = [TournamentViewModel(desc: true, date: true),
                                              TournamentViewModel(desc: true, date: false),
                                              TournamentViewModel(desc: false, date: true), TournamentViewModel(desc: false, date: false),
                                              TournamentViewModel(desc: true, date: true),
                                              TournamentViewModel(desc: true, date: false),
                                              TournamentViewModel(desc: false, date: true),
                                              TournamentViewModel(desc: false, date: false),
                                              TournamentViewModel(desc: true, date: false),
                                              TournamentViewModel(desc: false, date: true),
                                              TournamentViewModel(desc: false, date: false)]
                self.state = .rich
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
                //self.tournamentsViewModels = model.tournaments.compactMap { TournamentViewModel($0) }
                // моковый объект
                self.tournamentsViewModels = [TournamentViewModel(desc: true, date: true),
                                              TournamentViewModel(desc: true, date: false),
                                              TournamentViewModel(desc: false, date: true), TournamentViewModel(desc: false, date: false),
                                              TournamentViewModel(desc: true, date: true),
                                              TournamentViewModel(desc: true, date: false),
                                              TournamentViewModel(desc: false, date: true),
                                              TournamentViewModel(desc: false, date: false),
                                              TournamentViewModel(desc: true, date: false),
                                              TournamentViewModel(desc: false, date: true),
                                              TournamentViewModel(desc: false, date: false)]
                self.state = .rich
            case .serviceFailure:
                self.state = .error(code: 1)
            }
        }
    }
}
