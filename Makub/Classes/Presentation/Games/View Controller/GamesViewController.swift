//
//  GamesViewController.swift
//  Makub
//
//  Created by Елена Яновская on 02.04.2018.
//  Copyright © 2018 Elena Yanovskaya. All rights reserved.
//

import PKHUD
import UIKit

final class GamesViewController: UIViewController {
    
    private enum Constants {
        static let title = "Все игры"
        static let cellIdentifier = String(describing: GamesCell.self)
    }
    
    private enum LayoutConstants {
        static let tableViewHeight: CGFloat = 130
        static let leadingMargin: CGFloat = 5
        static let topEdge: CGFloat = 5
        static let bottomEdge: CGFloat = 5
        static let cellSpacing: CGFloat = 5
    }
    
    // MARK: - IBOutlets
    
    @IBOutlet private var navigationBar: UINavigationBar!
    @IBOutlet private var tournamentsButtonItem: UIBarButtonItem!
    @IBOutlet private var filterButtonItem: UIBarButtonItem!
    
    @IBOutlet private var gamesCollectionView: UICollectionView!
    
    // MARK: - Public Properties
    
    let presentationModel = GamesPresentationModel()
    
    // MARK: - Private Properties
    
    private let refreshControl = UIRefreshControl()
    
    // MARK: - ViewController lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = PaletteColors.blueBackground
        gamesCollectionView.backgroundColor = .clear
        gamesCollectionView.dataSource = self
        gamesCollectionView.delegate = self
        gamesCollectionView.register(UINib(nibName: Constants.cellIdentifier, bundle: nil), forCellWithReuseIdentifier: Constants.cellIdentifier)
        guard let flowLayout = gamesCollectionView.collectionViewLayout as? UICollectionViewFlowLayout else { return }
        flowLayout.estimatedItemSize.width = view.frame.width - 2 * LayoutConstants.leadingMargin
        flowLayout.estimatedItemSize.height = LayoutConstants.leadingMargin
        
        bindEvents()
        presentationModel.obtainGames()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        tabBarController?.delegate = self
    }
    
    // MARK: - Private Methods
    
    private func bindEvents() {
        presentationModel.changeStateHandler = { [weak self] status in
            switch status {
            case .loading:
                PKHUD.sharedHUD.dimsBackground = true
                PKHUD.sharedHUD.userInteractionOnUnderlyingViewsEnabled = false
                HUD.show(.progress)
            case .rich:
                self?.gamesCollectionView.reloadData()
                HUD.hide()
            case .error (let code):
                switch code {
                case -1009, -1001:
                    HUD.show(.labeledError(title: ErrorDescription.title.rawValue, subtitle: ErrorDescription.network.rawValue))
                case 2:
                    HUD.show(.labeledError(title: ErrorDescription.title.rawValue, subtitle: ErrorDescription.recover.rawValue))
                default:
                    HUD.show(.labeledError(title: ErrorDescription.title.rawValue, subtitle: ErrorDescription.server.rawValue))
                }
                HUD.hide(afterDelay: 1.0)
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                self?.refreshControl.endRefreshing()
            }
        }
    }
    
}

// MARK: - UICollectionViewDataSource

extension GamesViewController: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return presentationModel.viewModels.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let viewModel = presentationModel.viewModels[indexPath.row]
        let cellIdentifier = Constants.cellIdentifier
        guard let cell = gamesCollectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as? GamesCell else { return UICollectionViewCell() }
        
        cell.configure(for: viewModel)
        cell.layoutIfNeeded()
        return cell
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension GamesViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
            return UIEdgeInsets(top: LayoutConstants.topEdge, left: 0, bottom: LayoutConstants.bottomEdge, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return LayoutConstants.cellSpacing
    }
}


// MARK: - UITabBarControllerDelegate

extension GamesViewController: UITabBarControllerDelegate {
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        if tabBarController.selectedIndex == 2 {
            let indexPath = IndexPath(item: 0, section: 0)
            gamesCollectionView.scrollToItem(at: indexPath, at: .top, animated: true)
        }
    }
}
