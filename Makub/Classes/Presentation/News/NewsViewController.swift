//
//  NewsViewController.swift
//  Makub
//
//  Created by Елена Яновская on 20.03.2018.
//  Copyright © 2018 Elena Yanovskaya. All rights reserved.
//

import UIKit

final class NewsViewController: UIViewController {

    // MARK: - ViewController lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UINavigationBar.appearance().backgroundColor = .red

        view.backgroundColor = PaletteColors.blueBackground
        var searchBar = UISearchBar()
        searchBar.searchBarStyle = .default
        searchBar.sizeToFit()
        let textFieldInsideSearchBar = searchBar.value(forKey: "searchField") as? UITextField
        textFieldInsideSearchBar?.backgroundColor = UIColor.red
        var leftNavBarButton = UIBarButtonItem(customView: searchBar)
        self.navigationItem.leftBarButtonItem = leftNavBarButton
    }
    

    
    func imageFromColor(_ color: UIColor) -> UIImage {
        let rect = CGRect(x: 0, y: 0, width: 0, height: 0)
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()
        
        context?.setFillColor(color.cgColor);
        context?.fill(rect);
        
        let image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        return image!
    }
    
}

extension UIImage {
    
    public func blendedByColor(_ color: UIColor) -> UIImage {
        let scale = UIScreen.main.scale
        if scale > 1 {
            UIGraphicsBeginImageContextWithOptions(size, false, scale)
        } else {
            UIGraphicsBeginImageContext(size)
        }
        color.setFill()
        let bounds = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        UIRectFill(bounds)
        draw(in: bounds, blendMode: .destinationIn, alpha: 1)
        let blendedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return blendedImage!
    }
}
