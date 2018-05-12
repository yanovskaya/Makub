//
//  TournamentsService.swift
//  Makub
//
//  Created by Елена Яновская on 18.04.2018.
//  Copyright © 2018 Elena Yanovskaya. All rights reserved.
//

import Foundation

protocol TournamentsService: class {
    
    func obtainTournaments(useCache: Bool, from: Int, count: Int, completion: ((ServiceCallResult<TournamentsResponse>) -> Void)?)
    
}
