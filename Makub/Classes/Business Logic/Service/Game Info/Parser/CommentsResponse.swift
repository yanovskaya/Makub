//
//  CommentsResponse.swift
//  Makub
//
//  Created by Елена Яновская on 14.04.2018.
//  Copyright © 2018 Elena Yanovskaya. All rights reserved.
//

import Foundation

struct CommentsResponse: Decodable {
    
    let comments: [Comment]!
    let error: Int
}
