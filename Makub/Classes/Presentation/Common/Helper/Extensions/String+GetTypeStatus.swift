//
//  String+GetTypeStatus.swift
//  Makub
//
//  Created by Елена Яновская on 18.04.2018.
//  Copyright © 2018 Elena Yanovskaya. All rights reserved.
//

import Foundation.NSString

extension String {
    
    // MARK: - Constants
    
    private enum Constants {
        static let classicType = "Классика"
        static let quickType = "Быстрый"
        static let quichBPType = "Быстрый БП"
        
        static let friendGame = "Товарищеская игра"
        static let closeGame = "Закрытый турнир"
        static let openGame = "Открытый турнир"
        static let regionGame = "Чемпионат региона"
        static let russiaGame = "Чемпионат России"
    }
    
    // MARK: - Public Methods
    
    func getType() -> String {
        guard let typeId = Int(self) else {
            return ""
        }
        switch typeId {
        case 1:
            return Constants.classicType
        case 2:
            return Constants.quickType
        case 3:
            return Constants.quichBPType
        default:
            return ""
        }
    }
    
    func getStatus() -> String {
        guard let statusId = Int(self) else {
            return ""
        }
        switch statusId {
        case 1:
            return Constants.friendGame
        case 2:
            return Constants.closeGame
        case 3:
            return Constants.openGame
        case 4:
            return Constants.regionGame
        case 5:
            return Constants.russiaGame
        default:
            return ""
        }
    }
}
