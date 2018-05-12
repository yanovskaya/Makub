//
//  AchievementsPresentationModel.swift
//  Makub
//
//  Created by Елена Яновская on 21.04.2018.
//  Copyright © 2018 Elena Yanovskaya. All rights reserved.
//

import Foundation

final class AchievementsPresentationModel: PresentationModel {
    
    // MARK: - Public Properties
    
    var userViewModel: UserViewModel!
    var ratingViewModels = [RatingViewModel]()
    
    var title: String!
    
    // MARK: - Private Properties
    
    private let ratingService = ServiceLayer.shared.ratingService
    
    func obtainRating() {
        state = .loading
        ratingService.obtainRating(useCache: true) { result in
            switch result {
            case .serviceSuccess(let model):
                guard let model = model else { return }
                self.ratingViewModels = model.rating.compactMap { RatingViewModel($0) }
                self.obtainTypePositions()
                self.state = .rich
            case .serviceFailure(let error):
                self.state = .error(code: error.code)
            }
        }
    }
    
    // MARK: - Private Methods
    
    private func obtainTypePositions() {
        self.sortViewModels(type: .common)
        self.obtainUserPosition(type: .common)
        self.sortViewModels(type: .classic)
        self.obtainUserPosition(type: .classic)
        self.sortViewModels(type: .fast)
        self.obtainUserPosition(type: .fast)
        self.sortViewModels(type: .veryFast)
        self.obtainUserPosition(type: .veryFast)
    }
    
    private func obtainUserPosition(type: RatingType) {
        var position = 0
        for ratingViewModel in ratingViewModels {
            position += 1
            if ratingViewModel.id == userViewModel.id {
                switch type {
                case .common:
                    userViewModel.commonPosition = String(position)
                case .classic:
                    userViewModel.classicPosition = String(position)
                case .fast:
                    userViewModel.fastPosition = String(position)
                case .veryFast:
                    userViewModel.veryFastPosition = String(position)
                }
            }
        }
    }
    
    private func sortViewModels(type: RatingType) {
        ratingViewModels.sort {
            switch type {
            case .common:
                return $0.commonRating > $1.commonRating
            case .classic:
                return $0.classicRating > $1.classicRating
            case .fast:
                return $0.fastRating > $1.fastRating
            case .veryFast:
                return $0.veryFastRating > $1.veryFastRating
            }
        }
    }
}
