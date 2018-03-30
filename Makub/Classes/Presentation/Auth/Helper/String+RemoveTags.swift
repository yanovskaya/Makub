//
//  String+RemoveTags.swift
//  Makub
//
//  Created by Елена Яновская on 30.03.2018.
//  Copyright © 2018 Elena Yanovskaya. All rights reserved.
//

import Foundation.NSString

extension String {
    
    func removeTags() -> String {
        var editedString = replaceDivTag()
        editedString = editedString.components(separatedBy: "<div>").joined()
        editedString = editedString.components(separatedBy: "</div>").joined()
        editedString = editedString.components(separatedBy: "&nbsp;").joined()
        return editedString
    }
    
    private func replaceDivTag() -> String {
        return replacingOccurrences(of: "</div><div>", with: "\n", options: .literal, range: nil)
    }
}
