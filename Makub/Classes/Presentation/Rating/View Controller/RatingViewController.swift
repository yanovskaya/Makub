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
    @IBOutlet var commonButton: UIButton!
    @IBOutlet var classicButton: UIButton!
    @IBOutlet var fastButton: UIButton!
    @IBOutlet var veryFastButton: UIButton!
    
    @IBOutlet var indicatorButtonLeadingConstraint: NSLayoutConstraint!
    
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
        switch sender.tag {
        case 1:
            const = classicButton.frame.origin.x
        case 2:
             const = fastButton.frame.origin.x
        case 3:
             const = veryFastButton.frame.origin.x
        default:
             const = commonButton.frame.origin.x
        }
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 20, animations: ({
            self.indicatorView.frame.origin.x = const + 12
        }))
    }
}

// MARK: - UITabBarControllerDelegate

extension RatingViewController: UITabBarControllerDelegate {
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {}
}
