//
//  UIViewController+HideKeyboard.swift
//  Makub
//
//  Created by Елена Яновская on 14.03.2018.
//  Copyright © 2018 Elena Yanovskaya. All rights reserved.
//

import UIKit.UIViewController

extension UIViewController {
    
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
}
