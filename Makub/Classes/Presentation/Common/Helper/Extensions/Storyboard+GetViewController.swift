//
//  Storyboard+GetViewController.swift
//  Makub
//
//  Created by Елена Яновская on 17.03.2018.
//  Copyright © 2018 Elena Yanovskaya. All rights reserved.
//

import UIKit.UIStoryboard

extension UIStoryboard {

    convenience init(with title: StoryboardTitle) {
        self.init(name: title.rawValue, bundle: nil)
    }
    
    func viewController<T: UIViewController>(_ type: T.Type) -> T {
        let identifier = type.description().components(separatedBy: ".").last!
        return self.instantiateViewController(withIdentifier: identifier) as! T
    }
}
