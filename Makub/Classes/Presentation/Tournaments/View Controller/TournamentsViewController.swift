//
//  TournamentsViewController.swift
//  Makub
//
//  Created by Елена Яновская on 17.04.2018.
//  Copyright © 2018 Elena Yanovskaya. All rights reserved.
//

import PKHUD
import UIKit

class TournamentsViewController: UIViewController {
    
    // MARK: - Constants
    
    private enum Constants {
        static let title = "Все турниры"
        static let gamesImage = "fighting"
        static let cellIdentifier = String(describing: TournamentCell.self)
    }
    
    private enum LayoutConstants {
        static let leadingMargin: CGFloat = 5
        static let topEdge: CGFloat = 10
        static let bottomEdge: CGFloat = 10
        static let cellSpacing: CGFloat = 3
    }

    // MARK: - IBOutlets
    
    @IBOutlet private var navBackgroundView: UIView!
    @IBOutlet private var navigationBar: UINavigationBar!
    @IBOutlet private var tournamentsCollectionView: UICollectionView!
    
    @IBOutlet private var gamesButtonItem: UIBarButtonItem!
    
    // MARK: - Public Properties
    
    let presentationModel = TournamentsPresentationModel()
    
    // MARK: - Private Properties
    
    private var refreshControl = UIRefreshControl()
    
    // MARK: - ViewController lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = PaletteColors.blueBackground
        
        configureNavigationBar()
        configureCollectionView()
        
        bindEventsObtainTournaments()
        presentationModel.obtainTournamentsWithClubs()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        bindEventsObtainTournaments()
        tabBarController?.delegate = self
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        HUD.hide()
    }
    
    // MARK: - Public Methods
    
    private func bindEventsObtainTournaments() {
        presentationModel.changeStateHandler = { [weak self] status in
            switch status {
            case .loading:
                DispatchQueue.main.async {
                    HUD.show(.progress)
                }
            case .rich:
                self?.tournamentsCollectionView.reloadData()
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
    
    private func bindEventsRefreshTournaments() {
        presentationModel.changeStateHandler = { [weak self] status in
            switch status {
            case .loading:
                break
            case .rich:
                self?.tournamentsCollectionView.reloadData()
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
    
    // MARK: - Private Methods
    
    private func configureNavigationBar() {
        navigationController?.isNavigationBarHidden = true
        navBackgroundView.backgroundColor = .white
        let titleTextAttributes: [NSAttributedStringKey: Any] = [NSAttributedStringKey.foregroundColor: PaletteColors.darkGray,
                                                                 NSAttributedStringKey.font: UIFont.customFont(.robotoMediumFont(size: 17))]
        navigationBar.titleTextAttributes = titleTextAttributes
        navigationBar.topItem?.title = Constants.title
        navigationBar.shadowImage = UIImage(color: UIColor.white)
        navigationBar.setBackgroundImage(UIImage(color: UIColor.white), for: .default)
        
        gamesButtonItem.image = UIImage(named: Constants.gamesImage)
        gamesButtonItem.imageInsets = UIEdgeInsets(top: 2, left: 0, bottom: 0, right: 5)
        gamesButtonItem.tintColor = PaletteColors.darkGray
    }
    
    private func configureCollectionView() {
        tournamentsCollectionView.backgroundColor = .clear
        tournamentsCollectionView.dataSource = self
        tournamentsCollectionView.delegate = self
        tournamentsCollectionView.register(UINib(nibName: Constants.cellIdentifier, bundle: nil), forCellWithReuseIdentifier: Constants.cellIdentifier)
        tournamentsCollectionView.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(refreshTournaments(_:)), for: .valueChanged)
        
        guard let flowLayout = tournamentsCollectionView.collectionViewLayout as? UICollectionViewFlowLayout else { return }
        flowLayout.estimatedItemSize.width = view.frame.width - 2 * LayoutConstants.leadingMargin
    }
    
    @objc private func refreshTournaments(_ refreshControl: UIRefreshControl) {
        bindEventsRefreshTournaments()
        presentationModel.refreshTournaments()
    }

    private func routeBack() {
        let transition = CATransition()
        transition.type = kCATransitionReveal
        transition.subtype = kCATransitionFromRight
        transition.duration = 0.4
        transition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        navigationController?.view.layer.add(transition, forKey: nil)
        navigationController?.popToRootViewController(animated: false)
        dismiss(animated: false)
    }
    
    // MARK: - IBActions
    
    @IBAction private func gamesItemTapped(_ sender: Any) {
        routeBack()
    }
}

// MARK: - UICollectionViewDataSource

extension TournamentsViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return presentationModel.tournamentsViewModels.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let viewModel = presentationModel.tournamentsViewModels[indexPath.row]
        let cellIdentifier = Constants.cellIdentifier
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as? TournamentCell else { return UICollectionViewCell() }
        cell.configure(for: viewModel)
        cell.configureCellWidth(view.frame.width)
        cell.layoutIfNeeded()
        return cell
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension TournamentsViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: LayoutConstants.topEdge, left: 0, bottom: LayoutConstants.bottomEdge, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return LayoutConstants.cellSpacing
    }
}

// MARK: - UITabBarControllerDelegate

extension TournamentsViewController: UITabBarControllerDelegate {
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        let transition = CATransition()
        transition.type = kCATransitionReveal
        transition.subtype = kCATransitionFromRight
        transition.duration = 0.4
        transition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        self.navigationController?.view.layer.add(transition, forKey: nil)
       dismiss(animated: false)
    }
}
