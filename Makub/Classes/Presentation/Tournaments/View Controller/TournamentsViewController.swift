//
//  TournamentsViewController.swift
//  Makub
//
//  Created by Елена Яновская on 17.04.2018.
//  Copyright © 2018 Elena Yanovskaya. All rights reserved.
//

import UIKit

class TournamentsViewController: UIViewController {
    
    // MARK: - Constants
    
    private enum Constants {
        static let title = "Все турниры"
        static let pkhudTitle = "Подождите"
        static let pkhudSubtitle = "Идет фильтрация"
        static let filterImage = "filter"
        static let gamesImage = "fighting"
        static let cellIdentifier = String(describing: GamesCell.self)
    }
    
    private enum LayoutConstants {
        static let leadingMargin: CGFloat = 5
        static let topEdge: CGFloat = 10
        static let bottomEdge: CGFloat = 10
        static let cellSpacing: CGFloat = 3
    }

    @IBOutlet private var navBackgroundView: UIView!
    @IBOutlet private var navigationBar: UINavigationBar!
    @IBOutlet var tournamentsCollectionView: UICollectionView!
    
    @IBOutlet var gamesButtonItem: UIBarButtonItem!
    @IBOutlet var filterButtonItem: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = PaletteColors.blueBackground
        tabBarController?.delegate = self
        configureNavigationBar()
        configureCollectionView()
    }
    
    private func configureNavigationBar() {
        navigationController?.isNavigationBarHidden = true
        navBackgroundView.backgroundColor = .white
        let titleTextAttributes: [NSAttributedStringKey: Any] = [NSAttributedStringKey.foregroundColor: PaletteColors.darkGray,
                                                                 NSAttributedStringKey.font: UIFont.customFont(.robotoMediumFont(size: 17))]
        navigationBar.titleTextAttributes = titleTextAttributes
        navigationBar.topItem?.title = Constants.title
        navigationBar.shadowImage = UIImage(color: UIColor.white)
        navigationBar.setBackgroundImage(UIImage(color: UIColor.white), for: .default)
        
        filterButtonItem.image = UIImage(named: Constants.filterImage)
        filterButtonItem.imageInsets = UIEdgeInsets(top: 2, left: 0, bottom: 0, right: 5)
        filterButtonItem.tintColor = PaletteColors.darkGray
        
        gamesButtonItem.image = UIImage(named: Constants.gamesImage)
        gamesButtonItem.imageInsets = UIEdgeInsets(top: 2, left: 0, bottom: 0, right: 5)
        gamesButtonItem.tintColor = PaletteColors.darkGray
    }
    
    private func configureCollectionView() {
        tournamentsCollectionView.backgroundColor = .clear
//        gamesCollectionView.dataSource = self
//        gamesCollectionView.delegate = self
//        gamesCollectionView.loadControl = UILoadControl(target: self, action: #selector(obtainMoreGames(sender:)))
//        gamesCollectionView.register(UINib(nibName: Constants.cellIdentifier, bundle: nil), forCellWithReuseIdentifier: Constants.cellIdentifier)
//        gamesCollectionView.refreshControl = refreshControl
//        refreshControl.addTarget(self, action: #selector(refreshGames(_:)), for: .valueChanged)
        
        guard let flowLayout = tournamentsCollectionView.collectionViewLayout as? UICollectionViewFlowLayout else { return }
        flowLayout.estimatedItemSize.width = view.frame.width - 2 * LayoutConstants.leadingMargin
    }

    @IBAction func gamesItemTapped(_ sender: Any) {
        let gamesStoryboard = UIStoryboard(with: StoryboardTitle.games)
        let gameInfoViewController = gamesStoryboard.viewController(GamesViewController.self)
        let transition = CATransition()
        transition.type = kCATransitionReveal
        transition.subtype = kCATransitionFromRight
        transition.duration = 0.4
        transition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        navigationController?.view.layer.add(transition, forKey: nil)
        navigationController?.popToRootViewController(animated: false)
        dismiss(animated: false)
    }
}

// MARK: - UITabBarControllerDelegate

extension TournamentsViewController: UITabBarControllerDelegate {
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        let gamesStoryboard = UIStoryboard(with: StoryboardTitle.games)
        let gameInfoViewController = gamesStoryboard.viewController(GamesViewController.self)
        let transition = CATransition()
        transition.type = kCATransitionReveal
        transition.subtype = kCATransitionFromRight
        transition.duration = 0.4
        transition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        self.navigationController?.view.layer.add(transition, forKey: nil)
       dismiss(animated: false)
    }
}
