//
//  String+Tags.swift
//  Makub
//
//  Created by Елена Яновская on 30.03.2018.
//  Copyright © 2018 Elena Yanovskaya. All rights reserved.
//

import Foundation.NSString

extension String {
    
    // MARK: - Public Methods
    
    func addTags() -> String {
        let originString = self
        var editedString = ""
        for line in originString.components(separatedBy: "\n") {
            editedString.append("<div>\(line)</div>")
        }
        editedString = editedString.replacingOccurrences(of: "</div><div></div><div>", with: "</div><div>&nbsp;</div><div>", options: .literal, range: nil)
        return editedString
    }
    
    func removeTags() -> String {
        var editedString = replaceTags()
        editedString = editedString.components(separatedBy: "&nbsp;").joined()
        editedString = editedString.components(separatedBy: "<div>").joined()
        editedString = editedString.components(separatedBy: "</div>").joined()
        return editedString
    }
    
    // MARK: - Private Methods
    
    private func replaceTags() -> String {
        var newString = replacingOccurrences(of: "</div><div>", with: "\n", options: .literal, range: nil)
        newString = newString.replacingOccurrences(of: "&quot;", with: "\"", options: .literal, range: nil)
        return newString
    }
}
