//
//  String+CapitalizeFirstLetter.swift
//  Makub
//
//  Created by Елена Яновская on 16.04.2018.
//  Copyright © 2018 Elena Yanovskaya. All rights reserved.
//

import Foundation.NSString

extension String {
    
    func capitalizeFirstLetter() -> String {
        return prefix(1).uppercased() + dropFirst()
    }
}
