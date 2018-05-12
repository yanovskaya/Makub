//
//  GameInfoServiceImpl.swift
//  Makub
//
//  Created by Елена Яновская on 15.04.2018.
//  Copyright © 2018 Elena Yanovskaya. All rights reserved.
//

import Alamofire
import Foundation
import RealmSwift
import SwiftKeychainWrapper

final class GameInfoServiceImpl: GameInfoService {
    
    // MARK: - Constants
    
    private enum Constants {
        static let baseURL = "https://makub.ru/api"
        static let tokenParameter = "token"
        static let gameIdParameter = "game_id"
        static let idParameter = "id"
        static let playerIdParameter = "player_id"
        static let commentParameter = "comment"
    }
    
    private enum EndPoint {
        static let tournament = "/tournament_by_stage"
        static let comments = "/get_comments"
        static let addComment = "/add_comment"
        static let gameInfo = "/get_game_info"
    }
    
    // MARK: - Private Properties
    
    private let sessionManager: SessionManager
    private let transport: Transport
    private let commentsParser = Parser<CommentsResponse>()
    private let tournamentParser = Parser<TournamentResponse>()
    private let addCommentParser = Parser<AddCommentResponse>()
    private let gameInfoParser = Parser<GameInfo>()
    
    // MARK: - Initialization
    
    init(sessionManager: SessionManager) {
        self.sessionManager = sessionManager
        transport = Transport(sessionManager: sessionManager)
    }
    
    // MARK: - Public Methods
    
    func obtainGameInfo(gameId: Int, completion: ((ServiceCallResult<GameInfo>) -> Void)?) {
        guard let token = KeychainWrapper.standard.string(forKey: KeychainKeys.token) else {
            let error = NSError(domain: "", code: AdditionalErrors.tokenNotFound)
            completion?(ServiceCallResult.serviceFailure(error: error))
            return
        }
        let parameters = [Constants.tokenParameter: token,
                          Constants.idParameter: gameId] as [String: Any]
        transport.request(method: .post, url: Constants.baseURL + EndPoint.gameInfo, parameters: parameters) { [unowned self] transportResult in
            switch transportResult {
            case .transportSuccess(let payload):
                let resultBody = payload.resultBody
                let parseResult = self.gameInfoParser.parse(from: resultBody)
                switch parseResult {
                case .parserSuccess(let model):
                    completion?(ServiceCallResult.serviceSuccess(payload: model))
                case .parserFailure(let error):
                    completion?(ServiceCallResult.serviceFailure(error: error))
                }
            case .transportFailure(let error):
                completion?(ServiceCallResult.serviceFailure(error: error))
            }
        }
    }
    
    func obtainComments(gameId: Int, completion: ((ServiceCallResult<CommentsResponse>) -> Void)?) {
        guard let token = KeychainWrapper.standard.string(forKey: KeychainKeys.token) else {
            let error = NSError(domain: "", code: AdditionalErrors.tokenNotFound)
            completion?(ServiceCallResult.serviceFailure(error: error))
            return
        }
        let parameters = [Constants.tokenParameter: token,
                          Constants.gameIdParameter: gameId] as [String: Any]
        transport.request(method: .post, url: Constants.baseURL + EndPoint.comments, parameters: parameters) { [unowned self] transportResult in
            switch transportResult {
            case .transportSuccess(let payload):
                let resultBody = payload.resultBody
                let parseResult = self.commentsParser.parse(from: resultBody)
                switch parseResult {
                case .parserSuccess(let model):
                    if model.error == 0 {
                        completion?(ServiceCallResult.serviceSuccess(payload: model))
                    } else {
                        let error = NSError(domain: "", code: model.error)
                        completion?(ServiceCallResult.serviceFailure(error: error))
                    }
                case .parserFailure(let error):
                    completion?(ServiceCallResult.serviceFailure(error: error))
                }
            case .transportFailure(let error):
                completion?(ServiceCallResult.serviceFailure(error: error))
            }
        }
    }
    
    func obtainTournament(stage: Int, completion: ((ServiceCallResult<TournamentResponse>) -> Void)?) {
        guard let token = KeychainWrapper.standard.string(forKey: KeychainKeys.token) else {
            let error = NSError(domain: "", code: AdditionalErrors.tokenNotFound)
            completion?(ServiceCallResult.serviceFailure(error: error))
            return
        }
        let parameters = [Constants.tokenParameter: token,
                          Constants.idParameter: stage] as [String: Any]
        transport.request(method: .post, url: Constants.baseURL + EndPoint.tournament, parameters: parameters) { [unowned self] transportResult in
            switch transportResult {
            case .transportSuccess(let payload):
                let resultBody = payload.resultBody
                let parseResult = self.tournamentParser.parse(from: resultBody)
                switch parseResult {
                case .parserSuccess(let model):
                    if model.error == 0 {
                        completion?(ServiceCallResult.serviceSuccess(payload: model))
                    } else {
                        let error = NSError(domain: "", code: model.error)
                        completion?(ServiceCallResult.serviceFailure(error: error))
                    }
                case .parserFailure(let error):
                    completion?(ServiceCallResult.serviceFailure(error: error))
                }
            case .transportFailure(let error):
                completion?(ServiceCallResult.serviceFailure(error: error))
            }
        }
    }
    
    func addComment(gameId: Int, playerId: Int, comment: String, completion: ((ServiceCallResult<AddCommentResponse>) -> Void)?) {
        guard let token = KeychainWrapper.standard.string(forKey: KeychainKeys.token) else {
            let error = NSError(domain: "", code: AdditionalErrors.tokenNotFound)
            completion?(ServiceCallResult.serviceFailure(error: error))
            return
        }
        let parameters = [Constants.tokenParameter: token,
                          Constants.gameIdParameter: gameId,
                          Constants.playerIdParameter: playerId,
                          Constants.commentParameter: comment] as [String: Any]
        transport.request(method: .post, url: Constants.baseURL + EndPoint.addComment, parameters: parameters) { [unowned self] transportResult in
            switch transportResult {
            case .transportSuccess(let payload):
                let resultBody = payload.resultBody
                let parseResult = self.addCommentParser.parse(from: resultBody)
                switch parseResult {
                case .parserSuccess(let model):
                    if model.error == 0 {
                        completion?(ServiceCallResult.serviceSuccess(payload: model))
                    } else {
                        let error = NSError(domain: "", code: model.error)
                        completion?(ServiceCallResult.serviceFailure(error: error))
                    }
                case .parserFailure(let error):
                    completion?(ServiceCallResult.serviceFailure(error: error))
                }
            case .transportFailure(let error):
                completion?(ServiceCallResult.serviceFailure(error: error))
            }
        }
    }
}
