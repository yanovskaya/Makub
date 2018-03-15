//
//  Serializer.swift
//  Makub
//
//  Created by Елена Яновская on 15.03.2018.
//  Copyright © 2018 Elena Yanovskaya. All rights reserved.
//

import Foundation

final class Serializer {
    
    func serialize(_ inputValues: String) -> Data {
        return inputValues.data(using: String.Encoding.utf8)!
    }
}
