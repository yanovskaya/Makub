//
//  TournamentResponse.swift
//  Makub
//
//  Created by Елена Яновская on 15.04.2018.
//  Copyright © 2018 Elena Yanovskaya. All rights reserved.
//

import Foundation

struct TournamentResponse: Decodable {
    
    let tournament: Tournament!
    let error: Int
}
