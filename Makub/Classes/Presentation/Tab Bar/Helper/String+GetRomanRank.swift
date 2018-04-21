//
//  String+GetRomanRank.swift
//  Makub
//
//  Created by Елена Яновская on 21.04.2018.
//  Copyright © 2018 Elena Yanovskaya. All rights reserved.
//

import Foundation.NSString

extension String {
    
    func getRomanRank() -> String {
        switch self {
        case "1":
            return "I"
        case "2":
            return "II"
        case "3":
            return "III"
        case "4":
            return "IV"
        default:
            return "V"
            
        }
    }
}
