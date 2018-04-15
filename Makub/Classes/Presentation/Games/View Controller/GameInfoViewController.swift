//
//  GameInfoViewController.swift
//  Makub
//
//  Created by Елена Яновская on 14.04.2018.
//  Copyright © 2018 Elena Yanovskaya. All rights reserved.
//

import UIKit
import YouTubePlayer

final class GameInfoViewController: UIViewController {
    
    private enum Constants {
        static let backButtonImage = "down_arrow"
    }

    // MARK: - IBOutlets
    
    @IBOutlet private var navBackgroundView: UIView!
    @IBOutlet private var navigationBar: UINavigationBar!
    @IBOutlet private var backButtonItem: UIBarButtonItem!
    @IBOutlet private var gameCollectionView: UICollectionView!
    
    // MARK: - Public Properties
    
    let presentationModel = GameInfoPresentationModel()
    
    // MARK: - ViewController lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationBar.setBackgroundImage(UIImage(color: UIColor.white), for: .default)
        navBackgroundView.backgroundColor = .white
        backButtonItem.image = UIImage(named: Constants.backButtonImage)
        backButtonItem.tintColor = PaletteColors.darkGray
        gameCollectionView.backgroundColor = .clear
        view.backgroundColor = PaletteColors.blueBackground
        navigationController?.interactivePopGestureRecognizer?.delegate = nil
    }
}
