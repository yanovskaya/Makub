//
//  RatingService.swift
//  Makub
//
//  Created by Елена Яновская on 19.04.2018.
//  Copyright © 2018 Elena Yanovskaya. All rights reserved.
//

import Foundation

protocol RatingService: class {
    
    func obtainRating(useCache: Bool, completion: ((ServiceCallResult<RatingResponse>) -> Void)?)
}
