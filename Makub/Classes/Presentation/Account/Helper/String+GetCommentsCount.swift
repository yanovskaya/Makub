//
//  String+GetCommentsCount.swift
//  Makub
//
//  Created by Елена Яновская on 23.04.2018.
//  Copyright © 2018 Elena Yanovskaya. All rights reserved.
//

import Foundation.NSString

extension String {
    func getCommentsCount() -> String {
        switch self.last {
        case "1":
            return self + " " + "комментарий"
        case "2", "3", "4":
            return self + " " + "комментария"
        default:
            return self + " " + "комментариев"
        }
    }
}
