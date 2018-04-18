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
        static let pkhudTitle = "Подождите"
        static let pkhudSubtitle = "Идет фильтрация"
        static let tournamentImage = "trophy"
        static let filterImage = "filter"
        static let cellIdentifier = String(describing: GamesCell.self)
    }
    
    private enum LayoutConstants {
        static let leadingMargin: CGFloat = 5
        static let topEdge: CGFloat = 10
        static let bottomEdge: CGFloat = 10
        static let cellSpacing: CGFloat = 3
        static let estimatedCellHeight: CGFloat = 114
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
    
    private var refreshControl = UIRefreshControl()
    private var isLoading = false
    private var filterDataIsObtained = false
    private let router = GamesRouter()
    
    // MARK: - ViewController lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = PaletteColors.blueBackground
        
        configureNavigationBar()
        configureCollectionView()
        bindEventsObtainGames()
        presentationModel.obtainGamesWithClubs()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        bindEventsObtainGames()
        tabBarController?.delegate = self
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        HUD.hide()
    }
    
    // MARK: - Private Methods
    
    private func bindEventsObtainGames() {
        presentationModel.changeStateHandler = { [weak self] status in
            switch status {
            case .loading:
                HUD.show(.progress)
            case .rich:
                self?.gamesCollectionView.reloadData()
                self?.filterDataIsObtained = true
                
                HUD.hide()
            case .error (let code):
                switch code {
                case -1009, -1001:
                    HUD.show(.labeledError(title: ErrorDescription.title.rawValue, subtitle: ErrorDescription.network.rawValue))
                default:
                    HUD.show(.labeledError(title: ErrorDescription.title.rawValue, subtitle: ErrorDescription.server.rawValue))
                }
                HUD.hide(afterDelay: 1.0)
            }
        }
    }
    
    private func bindEventsObtainFilteredGames() {
        presentationModel.changeStateHandler = { [weak self] status in
            switch status {
            case .loading:
                HUD.show(.labeledProgress(title: Constants.pkhudTitle, subtitle: Constants.pkhudSubtitle))
            case .rich:
                self?.gamesCollectionView.reloadData()
                HUD.hide()
            case .error (let code):
                switch code {
                case -1009, -1001:
                    HUD.show(.labeledError(title: ErrorDescription.title.rawValue, subtitle: ErrorDescription.network.rawValue))
                default:
                    HUD.show(.labeledError(title: ErrorDescription.title.rawValue, subtitle: ErrorDescription.server.rawValue))
                }
                HUD.hide(afterDelay: 1.0)
                self?.filterButtonItem.tintColor = PaletteColors.darkGray
                self?.gamesCollectionView.addSubview(self!.refreshControl)
                self?.gamesCollectionView.loadControl = UILoadControl(target: self, action: #selector(self?.obtainMoreGames(sender:)))
                self?.presentationModel.chosenOptions = []
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                    self?.stopBindEvents()
                    self?.presentationModel.obtainGamesWithClubs()
                }
            }
        }
    }
    
    private func bindEventsRefreshGames() {
        presentationModel.changeStateHandler = { [weak self] status in
            switch status {
            case .loading:
                break
            case .rich:
                self?.gamesCollectionView.reloadData()
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                    self?.refreshControl.endRefreshing()
                }
            case .error:
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                    self?.refreshControl.endRefreshing()
                }
            }
        }
    }
    
    private func bindEventsObtainMoreGames() {
        presentationModel.changeStateHandler = { [weak self] status in
            switch status {
            case .loading:
                break
            case .rich:
                self?.gamesCollectionView.loadControl?.endLoading()
                self?.gamesCollectionView?.reloadData()
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                    self?.isLoading = false
                }
            case .error:
                self?.gamesCollectionView.loadControl?.endLoading()
                self?.isLoading = false
            }
        }
    }
    
    private func stopBindEvents() {
        presentationModel.changeStateHandler = { [weak self] status in
            switch status {
            case .rich:
                self?.gamesCollectionView.reloadData()
            default:
                break
            }
        }
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
        
        tournamentsButtonItem.image = UIImage(named: Constants.tournamentImage)
        tournamentsButtonItem.imageInsets = UIEdgeInsets(top: 2, left: 0, bottom: 0, right: 5)
        tournamentsButtonItem.tintColor = PaletteColors.darkGray
    }
    
    private func configureCollectionView() {
        gamesCollectionView.backgroundColor = .clear
        gamesCollectionView.dataSource = self
        gamesCollectionView.delegate = self
        gamesCollectionView.loadControl = UILoadControl(target: self, action: #selector(obtainMoreGames(sender:)))
        gamesCollectionView.register(UINib(nibName: Constants.cellIdentifier, bundle: nil), forCellWithReuseIdentifier: Constants.cellIdentifier)
        gamesCollectionView.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(refreshGames(_:)), for: .valueChanged)
        
        guard let flowLayout = gamesCollectionView.collectionViewLayout as? UICollectionViewFlowLayout else { return }
        flowLayout.estimatedItemSize.width = view.frame.width - 2 * LayoutConstants.leadingMargin
        flowLayout.estimatedItemSize.height = LayoutConstants.estimatedCellHeight
    }
    
    @objc private func refreshGames(_ refreshControl: UIRefreshControl) {
        bindEventsRefreshGames()
        presentationModel.refreshGames()
    }
    
    @objc private func obtainMoreGames(sender: AnyObject?) {
        if !isLoading {
            isLoading = true
            bindEventsObtainMoreGames()
            presentationModel.obtainMoreGames()
        } else {
            gamesCollectionView.loadControl?.endLoading()
        }
    }
    
    // MARK: - IBActions
    
    @IBAction func filterButtonItemTapped(_ sender: Any) {
        if filterDataIsObtained {
            router.presentFilterGamesVC(source: self)
        }
    }
    
    @IBAction func tournamentItemTapped(_ sender: Any) {
        router.showTournamentsVC(source: self)
    }
}

// MARK: - UICollectionViewDataSource

extension GamesViewController: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return presentationModel.gamesViewModels.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let viewModel = presentationModel.gamesViewModels[indexPath.row]
        let cellIdentifier = Constants.cellIdentifier
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as? GamesCell else { return UICollectionViewCell() }
        
        cell.configure(for: viewModel)
        cell.layoutIfNeeded()
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        router.showGameInfoVC(source: self, indexPath.row)
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

// MARK: - UIScrollViewDelegate

extension GamesViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        scrollView.loadControl?.update()
    }
}

// MARK: - FilterGamesViewControllerDelegate

extension GamesViewController: FilterViewControllerDelegate {
    
    func obtainAllItems(parameters: [String: [String]]) {
        bindEventsObtainFilteredGames()
        let topPoint = CGPoint(x: 0, y: 0)
        gamesCollectionView.setContentOffset(topPoint, animated: true)
        presentationModel.obtainAllGames(parameters: parameters)
        filterButtonItem.tintColor = PaletteColors.blueTint
        gamesCollectionView.loadControl = nil
        refreshControl.removeFromSuperview()
        gamesCollectionView.loadControl?.removeFromSuperview()
    }
    
    func showItemsWithNoFilter() {
        if refreshControl.superview == nil || gamesCollectionView.loadControl?.superview == nil {
            let topPoint = CGPoint(x: 0, y: 0)
            gamesCollectionView.setContentOffset(topPoint, animated: true)
            bindEventsObtainGames()
            presentationModel.obtainGamesWithClubs()
            filterButtonItem.tintColor = PaletteColors.darkGray
            gamesCollectionView.addSubview(refreshControl)
            gamesCollectionView.loadControl = UILoadControl(target: self, action: #selector(obtainMoreGames(sender:)))
        }
    }
    
    func saveChosenOptions(_ options: [IndexPath]) {
        presentationModel.saveChosenOptions(options)
    }
}
