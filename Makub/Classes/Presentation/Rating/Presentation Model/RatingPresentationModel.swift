//
//  RatingPresentationModel.swift
//  Makub
//
//  Created by Елена Яновская on 19.04.2018.
//  Copyright © 2018 Elena Yanovskaya. All rights reserved.
//

import Foundation
import UIKit

final class RatingPresentationModel: PresentationModel {
    
    // MARK: - Public Properties
    
    var ratingViewModels = [RatingViewModel]()
    
    // MARK: - Private Properties
    
    private let ratingService = ServiceLayer.shared.ratingService
    
    // MARK: - Public Methods
    
    func obtainRating() {
        state = .loading
        ratingService.obtainRating(useCache: true) { result in
            switch result {
            case .serviceSuccess(let model):
                guard let model = model else { return }
                self.ratingViewModels = model.rating.compactMap { RatingViewModel($0) }
                self.sortViewModels(type: .common)
                self.state = .rich
            case .serviceFailure(let error):
                self.state = .error(code: error.code)
            }
        }
    }
    
    func refreshRating(type: RatingType = .common) {
        ratingService.obtainRating(useCache: true) { result in
            switch result {
            case .serviceSuccess(let model):
                guard let model = model else { return }
                self.ratingViewModels = model.rating.compactMap { RatingViewModel($0) }
                self.sortViewModels(type: type)
                self.state = .rich
            case .serviceFailure(let error):
                self.state = .error(code: error.code)
            }
        }
    }
    
    func sortRating(for type: RatingType) {
        sortViewModels(type: type)
        self.state = .rich
    }
    
    // MARK: - Private Methods
    
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
