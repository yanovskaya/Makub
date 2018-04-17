//
//  GameInfoService.swift
//  Makub
//
//  Created by Елена Яновская on 14.04.2018.
//  Copyright © 2018 Elena Yanovskaya. All rights reserved.
//

import Foundation

protocol GameInfoService: class {
    
    func obtainComments(gameId: Int, completion: ((ServiceCallResult<CommentsResponse>) -> Void)?)
    
    func obtainTournament(stage: Int, completion: ((ServiceCallResult<TournamentResponse>) -> Void)?)
    
    func addComment(gameId: Int, playerId: Int, comment: String, completion: ((ServiceCallResult<AddCommentResponse>) -> Void)?)
}
