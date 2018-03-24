//
//  NewsService.swift
//  Makub
//
//  Created by Елена Яновская on 24.03.2018.
//  Copyright © 2018 Elena Yanovskaya. All rights reserved.
//

import Foundation

protocol NewsService: class {
    
    func obtainNews(completion: ((ServiceCallResult<NewsResponse>) -> Void)?)
    func obtainRealmCache(error: NSError?, completion: ((ServiceCallResult<NewsResponse>) -> Void)?)
}
