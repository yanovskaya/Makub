//
//  ClubsService.swift
//  Makub
//
//  Created by Елена Яновская on 18.04.2018.
//  Copyright © 2018 Elena Yanovskaya. All rights reserved.
//

import Foundation

protocol ClubsService: class {
    
    func obtainClubs(useCache: Bool, completion: ((ServiceCallResult<ClubsResponse>) -> Void)?)
    func obtainClubsRealmCache(error: NSError?, completion: ((ServiceCallResult<ClubsResponse>) -> Void)?)
}
