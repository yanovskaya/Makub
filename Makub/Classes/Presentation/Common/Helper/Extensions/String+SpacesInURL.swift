//
//  String+SpacesInURL.swift
//  Makub
//
//  Created by Елена Яновская on 03.04.2018.
//  Copyright © 2018 Elena Yanovskaya. All rights reserved.
//

import Foundation.NSString

extension String {
    
    func encodeInURL() -> String {
        return self.addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed)!
    }
}
