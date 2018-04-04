//
//  GamesViewController.swift
//  Makub
//
//  Created by Елена Яновская on 02.04.2018.
//  Copyright © 2018 Elena Yanovskaya. All rights reserved.
//

import PKHUD
import UIKit
import UILoadControl

final class GamesViewController: UIViewController {
    
    // MARK: - Constants
    
    private enum Constants {
        static let title = "Все игры"
        static let cellIdentifier = String(describing: GamesCell.self)
    }
    
    private enum LayoutConstants {
        static let leadingMargin: CGFloat = 5
        static let topEdge: CGFloat = 5
        static let bottomEdge: CGFloat = 5
        static let cellSpacing: CGFloat = 3
    }
    
    // MARK: - IBOutlets
    
    @IBOutlet private var navigationBar: UINavigationBar!
    @IBOutlet private var tournamentsButtonItem: UIBarButtonItem!
    @IBOutlet private var filterButtonItem: UIBarButtonItem!
    @IBOutlet private var navBackgroundView: UIView!
    
    @IBOutlet private var gamesCollectionView: UICollectionView!
    
    // MARK: - Public Properties
    
    let presentationModel = GamesPresentationModel()
    
    // MARK: - Private Properties
    
    private let refreshControl = UIRefreshControl()
    private var isLoading = false {
        didSet {
            print(isLoading)
        }
    }
    
    // MARK: - ViewController lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = PaletteColors.blueBackground
        navBackgroundView.backgroundColor = .white
        let titleTextAttributes: [NSAttributedStringKey: Any] = [NSAttributedStringKey.foregroundColor: PaletteColors.darkGray,
                                                                 NSAttributedStringKey.font: UIFont.customFont(.robotoMediumFont(size: 17))]
        navigationBar.titleTextAttributes = titleTextAttributes
        navigationBar.topItem?.title = Constants.title
        navigationController?.isNavigationBarHidden = true
        navigationBar.shadowImage = UIImage(color: UIColor.white)
        navigationBar.setBackgroundImage(UIImage(color: UIColor.white), for: .default)
        
        gamesCollectionView.backgroundColor = .clear
        gamesCollectionView.dataSource = self
        gamesCollectionView.delegate = self
        gamesCollectionView.loadControl = UILoadControl(target: self, action: #selector(loadMore(sender:)))
        gamesCollectionView.register(UINib(nibName: Constants.cellIdentifier, bundle: nil), forCellWithReuseIdentifier: Constants.cellIdentifier)
        guard let flowLayout = gamesCollectionView.collectionViewLayout as? UICollectionViewFlowLayout else { return }
        flowLayout.estimatedItemSize.width = view.frame.width - 2 * LayoutConstants.leadingMargin
        
        bindEvents()
        presentationModel.obtainGames()
        
        gamesCollectionView.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(refresh(_:)), for: .valueChanged)
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
                HUD.show(.progress)
            case .rich:
                self?.gamesCollectionView.loadControl?.endLoading()
                self?.gamesCollectionView.reloadData()
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                    self?.isLoading = false
                }
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
    
    @objc private func refresh(_ refreshControl: UIRefreshControl) {
        presentationModel.refreshGames()
    }
    
     @objc func loadMore(sender: AnyObject?) {
        print("REFRESH")
        if !isLoading {
            isLoading = true
            presentationModel.obtainMoreGames()
        } else {
            gamesCollectionView.loadControl?.endLoading()
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
            let topPoint = CGPoint(x: 0, y: 0)
            gamesCollectionView.setContentOffset(topPoint, animated: true)
        }
    }
}

extension GamesViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        scrollView.loadControl?.update()
    }
}
