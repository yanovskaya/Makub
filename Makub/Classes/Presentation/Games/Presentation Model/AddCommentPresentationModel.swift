//
//  AddCommentPresentationModel.swift
//  Makub
//
//  Created by Елена Яновская on 17.04.2018.
//  Copyright © 2018 Elena Yanovskaya. All rights reserved.
//

import Foundation

final class AddCommentPresentationModel: PresentationModel {
    
    // MARK: - Public Properties
    
    var userViewModel: UserViewModel!
    var gameViewModel: GameViewModel!
    
    // MARK: - Private Properties
    
    private let gameInfoService = ServiceLayer.shared.gameInfoService
    
    // MARK: - Public Methods
    
    func addComment(comment: String) {
        state = .loading
        guard let gameId = Int(gameViewModel.id),
            let playerId = Int(userViewModel.id) else { return }
        gameInfoService.addComment(gameId: gameId, playerId: playerId, comment: comment) { result in
            switch result {
            case .serviceSuccess:
                self.state = .rich
            case .serviceFailure(let error):
                self.state = .error(code: error.code)
            }
        }
    }
}
