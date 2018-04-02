//
//  GamesService.swift
//  Makub
//
//  Created by Елена Яновская on 02.04.2018.
//  Copyright © 2018 Elena Yanovskaya. All rights reserved.
//

import Foundation

protocol GamesService: class {
    
    func obtainAllGames(from: Int, to: Int, completion: ((ServiceCallResult<GamesResponse>) -> Void)?)
    func obtainRealmCache(error: NSError?, completion: ((ServiceCallResult<GamesResponse>) -> Void)?)
    
}
