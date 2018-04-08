//
//  UIImage+DrawCircle.swift
//  Makub
//
//  Created by Елена Яновская on 07.04.2018.
//  Copyright © 2018 Elena Yanovskaya. All rights reserved.
//

import UIKit.UIImage

extension UIImage {
    
    func drawEmptyCircle() -> UIImage? {
        UIGraphicsBeginImageContext(size)
        draw(at: CGPoint.zero)
        
        let width = size.width / 30
        let height = size.height / 30
        
        let context = UIGraphicsGetCurrentContext()!
        
        context.setStrokeColor(PaletteColors.textGray.cgColor)
        context.setLineWidth(width)
        context.addEllipse(in: CGRect(x: width / 2,
                                      y: height / 2,
                                      width: size.width - width,
                                      height: size.height - height))
        context.drawPath(using: .stroke)
        
        let circle = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return circle
    }
    
    func drawFilledCircle() -> UIImage? {
        UIGraphicsBeginImageContext(size)
        draw(at: CGPoint.zero)
        
        let height = size.height * 0.25
        let width = size.width * 0.25

        let context = UIGraphicsGetCurrentContext()!

        context.setStrokeColor(PaletteColors.blueTint.cgColor)
        context.setLineWidth(width)
        context.addEllipse(in: CGRect(x: (size.width - width) / 2,
                                      y: (size.height - height) / 2,
                                      width: width,
                                      height: height))
        context.drawPath(using: .stroke)
        
        let circle = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return circle
    }
}
