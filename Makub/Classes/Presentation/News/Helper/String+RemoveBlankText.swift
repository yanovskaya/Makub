//
//  String+RemoveBlankText.swift
//  Makub
//
//  Created by Елена Яновская on 31.03.2018.
//  Copyright © 2018 Elena Yanovskaya. All rights reserved.
//

import Foundation.NSString

extension String {
    
    func removeBlankText() -> String {
        for character in self where character != " " {
            return self
        }
        return ""
    }
}
