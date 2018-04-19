//
//  RatingResponse.swift
//  Makub
//
//  Created by Елена Яновская on 19.04.2018.
//  Copyright © 2018 Elena Yanovskaya. All rights reserved.
//

import Foundation

struct RatingResponse: Decodable {
    
    let rating: [Rating]!
    let error: Int
    
    private enum CodingKeys: CodingKey, String {
        case rating = "main"
        case error
    }
}
