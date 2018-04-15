//
//  GameInfoPresentationModel.swift
//  Makub
//
//  Created by Елена Яновская on 14.04.2018.
//  Copyright © 2018 Elena Yanovskaya. All rights reserved.
//

import Foundation

final class GameInfoPresentationModel: PresentationModel {
    
    // MARK: - Public Properties
    
    var gameViewModel: GameViewModel!
    var tournamentViewModel: TournamentViewModel!
    var commentViewModels: [CommentViewModel]!
    
    // MARK: - Private Properties
    
    private let group = DispatchGroup()
    private var error: Int!
}
