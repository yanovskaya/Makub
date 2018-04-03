//
//  NewsServiceImpl.swift
//  Makub
//
//  Created by Елена Яновская on 03.04.2018.
//  Copyright © 2018 Elena Yanovskaya. All rights reserved.
//

import Alamofire
import Foundation
import RealmSwift
import SwiftKeychainWrapper

final class NewsServiceImpl: NewsService {
    
    // MARK: - Constants
    
    private enum Constants {
        static let baseURL = "https://makub.ru/api"
        static let tokenParameter = "token"
        
        static let titleParameter = "title"
        static let textParameter = "text"
        static let imageParameter = "image"
        
        static let jpgExtension = ".jpg"
    }
    
    private enum EndPoint {
        static let news = "/news"
        static let addNews = "/add_article"
    }
    
    // MARK: - Private Properties
    
    private let transport = Transport()
    private let newsParser = Parser<NewsResponse>()
    private let addNewsParser = Parser<AddNewsResponse>()
    private let realmCache = RealmCache<News>()
    
    // MARK: - Public Methods
    
    func obtainNews(completion: ((ServiceCallResult<NewsResponse>) -> Void)?) {
        guard let token = KeychainWrapper.standard.string(forKey: KeychainKey.token) else {
            let error = NSError(domain: "", code: AdditionalErrors.tokenNotFound)
            completion?(ServiceCallResult.serviceFailure(error: error))
            return
        }
        let parameters = [Constants.tokenParameter: token]
        transport.request(method: .post, url: Constants.baseURL + EndPoint.news, parameters: parameters) { [unowned self] transportResult in
            switch transportResult {
            case .transportSuccess(let payload):
                let resultBody = payload.resultBody
                let parseResult = self.newsParser.parse(from: resultBody)
                switch parseResult {
                case .parserSuccess(let model):
                    if model.error == 0 {
                        self.realmCache.refreshCache(model.news)
                        completion?(ServiceCallResult.serviceSuccess(payload: model))
                    } else {
                        let error = NSError(domain: "", code: model.error)
                        completion?(ServiceCallResult.serviceFailure(error: error))
                    }
                case .parserFailure(let error):
                    self.obtainRealmCache(error: error, completion: completion)
                }
            case .transportFailure(let error):
                self.obtainRealmCache(error: error, completion: completion)
            }
        }
    }
    
    func addNews(title: String, text: String, completion: ((ServiceCallResult<AddNewsResponse>) -> Void)?) {
        guard let token = KeychainWrapper.standard.string(forKey: KeychainKey.token) else {
            let error = NSError(domain: "", code: AdditionalErrors.tokenNotFound)
            completion?(ServiceCallResult.serviceFailure(error: error))
            return
        }
        let parameters = [Constants.tokenParameter: token,
                          Constants.titleParameter: title,
                          Constants.textParameter: text]
        transport.request(method: .post, url: Constants.baseURL + EndPoint.addNews, parameters: parameters) { [unowned self] transportResult in
            switch transportResult {
            case .transportSuccess(let payload):
                let resultBody = payload.resultBody
                let parseResult = self.addNewsParser.parse(from: resultBody)
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
    
    func addNewsWithImage(title: String, text: String, image: UIImage, completion: ((ServiceCallResult<AddNewsResponse>) -> Void)?) {
        guard let token = KeychainWrapper.standard.string(forKey: KeychainKey.token) else {
            let error = NSError(domain: "", code: AdditionalErrors.tokenNotFound)
            completion?(ServiceCallResult.serviceFailure(error: error))
            return
        }
        let parameters = [Constants.tokenParameter: token,
                          Constants.titleParameter: title,
                          Constants.textParameter: text]
        let imageData = UIImageJPEGRepresentation(image, 1)
        let randomName = String(length: 5)
        transport.upload(method: .post,
                         url: Constants.baseURL + EndPoint.addNews,
                         parameters: parameters,
                         data: imageData!,
                         name: Constants.imageParameter,
                         fileName: randomName + Constants.jpgExtension) { transportResult in
                            switch transportResult {
                            case .transportSuccess(let payload):
                                let resultBody = payload.resultBody
                                let parseResult = self.addNewsParser.parse(from: resultBody)
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
    
    func obtainRealmCache(error: NSError? = nil, completion: ((ServiceCallResult<NewsResponse>) -> Void)?) {
        if let newsCache = self.realmCache.getCachedArray() {
            let newsResponse = NewsResponse(news: newsCache, error: 0)
            completion?(ServiceCallResult.serviceSuccess(payload: newsResponse))
        } else {
            guard let error = error else {
                completion?(ServiceCallResult.serviceFailure(error: NSError()))
                return
            }
            completion?(ServiceCallResult.serviceFailure(error: error))
        }
    }
    
}
