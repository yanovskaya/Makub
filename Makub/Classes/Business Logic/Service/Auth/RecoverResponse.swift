//
//  RecoverResponse.swift
//  Makub
//
//  Created by Елена Яновская on 20.03.2018.
//  Copyright © 2018 Elena Yanovskaya. All rights reserved.
//

import Foundation

struct RecoverResponse: Decodable {
    let error: Int
    
    private enum CodingKeys: String, CodingKey {
        case error
    }
}
