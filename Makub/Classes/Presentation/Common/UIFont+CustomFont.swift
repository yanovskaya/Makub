//
//  UIFont+CustomFont.swift
//  Makub
//
//  Created by Елена Яновская on 13.03.2018.
//  Copyright © 2018 Elena Yanovskaya. All rights reserved.
//

import UIKit.UIFont

extension UIFont {
    
    enum FontType {
        case robotoRegularFont(size: CGFloat)
        case robotoMediumFont(size: CGFloat)
        case robotoBoldFont(size: CGFloat)
        case robotoLightFont(size: CGFloat)
    }
    
    static func customFont(_ fontType: FontType) -> UIFont {
        switch fontType {
        case let .robotoMediumFont(size):
            return UIFont(name: "roboto.medium.ttf", size: size) ?? UIFont.systemFont(ofSize: size)
        case let .robotoRegularFont(size):
            return UIFont(name: "roboto.regular.ttf", size: size) ?? UIFont.systemFont(ofSize: size)
        case let .robotoBoldFont(size):
            return UIFont(name: "roboto.bold.ttf", size: size) ?? UIFont.systemFont(ofSize: size)
        case let .robotoLightFont(size):
            return UIFont(name: "roboto.light.ttf", size: size) ?? UIFont.systemFont(ofSize: size)
        }
    }
}
