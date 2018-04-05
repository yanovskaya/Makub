//
//  NewsService.swift
//  Makub
//
//  Created by Елена Яновская on 03.04.2018.
//  Copyright © 2018 Elena Yanovskaya. All rights reserved.
//

import Foundation
import UIKit

protocol NewsService: class {
    
    func obtainNews(completion: ((ServiceCallResult<NewsResponse>) -> Void)?)
    func obtainRealmCache(error: NSError?, completion: ((ServiceCallResult<NewsResponse>) -> Void)?)
    
    func addNews(title: String, text: String, completion: ((ServiceCallResult<AddNewsResponse>) -> Void)?)
    func addNewsWithImage(title: String, text: String, image: UIImage, completion: ((ServiceCallResult<AddNewsResponse>) -> Void)?)
    func deleteNews(id: Int, completion: ((ServiceCallResult<DeleteNewsResponse>) -> Void)?)
}
