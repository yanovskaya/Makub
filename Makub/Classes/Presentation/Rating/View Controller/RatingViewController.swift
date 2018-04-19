//
//  RatingViewController.swift
//  Makub
//
//  Created by Елена Яновская on 20.03.2018.
//  Copyright © 2018 Elena Yanovskaya. All rights reserved.
//

import UIKit

final class RatingViewController: UIViewController {
    
    @IBOutlet private var navigationBar: UINavigationBar!
    @IBOutlet private var indicatorView: UIView!
    @IBOutlet private var commonButton: UIButton!
    @IBOutlet private var classicButton: UIButton!
    @IBOutlet private var fastButton: UIButton!
    @IBOutlet private var veryFastButton: UIButton!
    
    @IBOutlet private var indicatorButtonLeadingConstraint: NSLayoutConstraint!
    
    // MARK: - ViewController lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.isNavigationBarHidden = true
        
        view.backgroundColor = PaletteColors.blueBackground
        indicatorView.backgroundColor = PaletteColors.blueTint
        indicatorView.clipsToBounds = true
        indicatorView.layer.cornerRadius = 5
        indicatorView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        
        navigationBar.shadowImage = UIImage(color: UIColor.white)
        navigationBar.setBackgroundImage(UIImage(color: UIColor.white), for: .default)
        commonButton.tintColor = PaletteColors.blueTint
        classicButton.tintColor = PaletteColors.lightGray
        fastButton.tintColor = PaletteColors.lightGray
        veryFastButton.tintColor = PaletteColors.lightGray
        
        commonButton.tag = 0
        classicButton.tag = 1
        fastButton.tag = 2
        veryFastButton.tag = 3
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        tabBarController?.delegate = self
    }
    
    @IBAction func typeButtonTapped(_ sender: UIButton) {
        indicatorButtonLeadingConstraint.isActive = false
        var const: CGFloat!
        var button: UIButton
        switch sender.tag {
        case 1:
            const = classicButton.frame.origin.x
            button = classicButton
        case 2:
             const = fastButton.frame.origin.x
            button = fastButton
        case 3:
             const = veryFastButton.frame.origin.x
            button = veryFastButton
        default:
             const = commonButton.frame.origin.x
            button = commonButton
        }
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 20, animations: ({
            self.indicatorView.frame.origin.x = const + 12
            
            self.commonButton.tintColor = PaletteColors.lightGray
            self.classicButton.tintColor = PaletteColors.lightGray
            self.fastButton.tintColor = PaletteColors.lightGray
            self.veryFastButton.tintColor = PaletteColors.lightGray
            button.tintColor = PaletteColors.blueTint
        }))
    }
}

// MARK: - UITabBarControllerDelegate

extension RatingViewController: UITabBarControllerDelegate {
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {}
}
