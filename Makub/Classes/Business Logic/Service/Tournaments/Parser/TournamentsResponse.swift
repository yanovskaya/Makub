//
//  TournamentsResponse.swift
//  Makub
//
//  Created by Елена Яновская on 18.04.2018.
//  Copyright © 2018 Elena Yanovskaya. All rights reserved.
//

import Foundation

struct TournamentsResponse: Decodable {
    
    let tournaments: [Tournament]!
    let error: Int
}
