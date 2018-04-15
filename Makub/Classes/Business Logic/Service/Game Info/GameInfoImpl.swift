//
//  GameInfoImpl.swift
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
        static let stageParameter = "stage"
    }
    
    private enum EndPoint {
        static let tournament = "/tournament_by_stage"
        static let comments = "/get_comments"
    }
    
    // MARK: - Private Properties
    
    private let sessionManager: SessionManager
    private let transport: Transport
    private let commentsParser = Parser<CommentsResponse>()
    private let tournamentParser = Parser<TournamentResponse>()
    
    private let commentsRealmCache = RealmCache<Comment>()
    private let tournamentRealmCache = RealmCache<Tournament>()
    
    // MARK: - Initialization
    
    init(sessionManager: SessionManager) {
        self.sessionManager = sessionManager
        transport = Transport(sessionManager: sessionManager)
    }
    
    // MARK: - Public Methods
    
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
                        self.commentsRealmCache.refreshCache(model.comments)
                        completion?(ServiceCallResult.serviceSuccess(payload: model))
                    } else {
                        let error = NSError(domain: "", code: model.error)
                        completion?(ServiceCallResult.serviceFailure(error: error))
                    }
                case .parserFailure(let error):
                    self.obtainCommentsRealmCache(error: error, completion: completion)
                }
            case .transportFailure(let error):
                self.obtainCommentsRealmCache(error: error, completion: completion)
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
                          Constants.stageParameter: stage] as [String: Any]
        transport.request(method: .post, url: Constants.baseURL + EndPoint.comments, parameters: parameters) { [unowned self] transportResult in
            switch transportResult {
            case .transportSuccess(let payload):
                let resultBody = payload.resultBody
                let parseResult = self.tournamentParser.parse(from: resultBody)
                switch parseResult {
                case .parserSuccess(let model):
                    if model.error == 0 {
                        self.tournamentRealmCache.refreshCache(model.tournament)
                        completion?(ServiceCallResult.serviceSuccess(payload: model))
                    } else {
                        let error = NSError(domain: "", code: model.error)
                        completion?(ServiceCallResult.serviceFailure(error: error))
                    }
                case .parserFailure(let error):
                    self.obtainTournamentRealmCache(error: error, completion: completion)
                }
            case .transportFailure(let error):
                self.obtainTournamentRealmCache(error: error, completion: completion)
            }
        }
    }
    
    // MARK: - Private Methods
    
    private func obtainCommentsRealmCache(error: NSError? = nil, completion: ((ServiceCallResult<CommentsResponse>) -> Void)?) {
        if let commentsCache = self.commentsRealmCache.getCachedArray() {
            let commentsResponse = CommentsResponse(comments: commentsCache, error: 0)
            completion?(ServiceCallResult.serviceSuccess(payload: commentsResponse))
        } else {
            guard let error = error else {
                completion?(ServiceCallResult.serviceFailure(error: NSError()))
                return
            }
            completion?(ServiceCallResult.serviceFailure(error: error))
        }
    }
    
    private func obtainTournamentRealmCache(error: NSError? = nil, completion: ((ServiceCallResult<TournamentResponse>) -> Void)?) {
        if let tournamentCache = self.tournamentRealmCache.getCachedObject() {
            let tournamentResponse = TournamentResponse(tournament: tournamentCache, error: 0)
            completion?(ServiceCallResult.serviceSuccess(payload: tournamentResponse))
        } else {
            guard let error = error else {
                completion?(ServiceCallResult.serviceFailure(error: NSError()))
                return
            }
            completion?(ServiceCallResult.serviceFailure(error: error))
        }
    }
    
}
