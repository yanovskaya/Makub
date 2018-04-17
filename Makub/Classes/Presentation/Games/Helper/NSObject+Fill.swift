//
//  NSObject+Fill.swift
//  Makub
//
//  Created by Елена Яновская on 07.04.2018.
//  Copyright © 2018 Elena Yanovskaya. All rights reserved.
//

import Foundation.NSObject

extension NSObject {
    
    func fill<T>(_ action: (T) -> Void) -> T! {
        return self as! T
    }
}
