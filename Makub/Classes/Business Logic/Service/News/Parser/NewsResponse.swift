//
//  NewsResponse.swift
//  Makub
//
//  Created by Елена Яновская on 24.03.2018.
//  Copyright © 2018 Elena Yanovskaya. All rights reserved.
//

import Foundation

struct NewsResponse: Decodable {
    
    let news: [News]!
    let error: Int
}
