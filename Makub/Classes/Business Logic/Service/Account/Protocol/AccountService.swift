//
//  AccountService.swift
//  Makub
//
//  Created by Елена Яновская on 23.04.2018.
//  Copyright © 2018 Elena Yanovskaya. All rights reserved.
//

import Foundation

protocol AccountService: class {
    
    func obtainUserGames(from: Int, to: Int, useCache: Bool, completion: ((ServiceCallResult<UserGamesResponse>) -> Void)?)
}
