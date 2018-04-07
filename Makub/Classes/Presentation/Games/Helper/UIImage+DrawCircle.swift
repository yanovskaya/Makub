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
        
        let context = UIGraphicsGetCurrentContext()!
        
        context.setStrokeColor(PaletteColors.textGray.cgColor)
         let lineWidth = size.width / 30
        context.setLineWidth(lineWidth)
        context.addEllipse(in: CGRect(x: lineWidth / 2, y: lineWidth / 2, width: size.width - lineWidth, height: size.height - lineWidth))
        context.drawPath(using: .stroke)
        
        let circle = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return circle
    }
    
    func drawFilledCircle() -> UIImage? {
        UIGraphicsBeginImageContext(size)
        draw(at: CGPoint.zero)

        let context = UIGraphicsGetCurrentContext()!

        context.setStrokeColor(PaletteColors.blueTint.cgColor)
        
        let height = size.height * 0.25
        let width = size.width * 0.25
        context.setLineWidth(width)
        context.addEllipse(in: CGRect(x: size.width / 2 - width / 2, y: size.height / 2 - height / 2, width: width, height: height))
        context.drawPath(using: .stroke)
        
        let circle = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return circle
    }
}
