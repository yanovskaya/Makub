//
//  AchievementsViewController.swift
//  Makub
//
//  Created by Елена Яновская on 21.04.2018.
//  Copyright © 2018 Elena Yanovskaya. All rights reserved.
//

import PKHUD
import UIKit

final class AchievementsViewController: UICollectionViewController {

    // MARK: - Constants
    
    private enum Constants {
        static let backImage = "arrow_left"
        static let userCellId = String(describing: UserCell.self)
        static let gamesCellId = String(describing: GamesAchievementsCell.self)
        static let cupsCellId = String(describing: CupsAchievementsCell.self)
    }
    
    private enum LayoutConstants {
        static let leadingMargin: CGFloat = 5
        static let topEdge: CGFloat = 10
        static let bottomEdge: CGFloat = 15
        static let estimatedCellHeight: CGFloat = 114
        static let cellSpacing: CGFloat = 3
    }
    
    // MARK: - Public Properties
    
    let presentationModel = AchievementsPresentationModel()
    
    // MARK: - Private Properties
    
    private let router = AccountRouter()
    
    // MARK: - ViewController lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = PaletteColors.blueBackground
        configureCollectionView()
        configureNavigationBar()
        bindEvents()
        presentationModel.obtainRating()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        HUD.hide()
    }
    
    // MARK: - UICollectionViewDataSource
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        if !presentationModel.ratingViewModels.isEmpty {
            return 3
        } else {
            return 0
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 || section == 1 {
            return 1
        } else {
            return presentationModel.userViewModel.achievements.count
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let section = indexPath.section
        if section == 0 {
            return userCell(collectionView, cellForItemAt: indexPath)
        } else if indexPath.section == 1 {
            return gamesCell(collectionView, cellForItemAt: indexPath)
        } else {
            return cupsCell(collectionView, cellForItemAt: indexPath)
        }
    }
    
    // MARK: - Private Methods
   
    private func bindEvents() {
        presentationModel.changeStateHandler = { [weak self] status in
            switch status {
            case .loading:
                DispatchQueue.main.async {
                    HUD.show(.progress)
                }
            case .rich:
                self?.collectionView?.reloadData()
                HUD.hide()
            case .error (let code):
                switch code {
                case -1009, -1001:
                    HUD.show(.labeledError(title: ErrorDescription.title.rawValue, subtitle: ErrorDescription.network.rawValue))
                default:
                    HUD.show(.labeledError(title: ErrorDescription.title.rawValue, subtitle: ErrorDescription.server.rawValue))
                }
                HUD.hide(afterDelay: 1.0)
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    self?.navigationController?.popViewController(animated: true)
                }
            }
        }
    }
    
    private func configureNavigationBar() {
        let titleTextAttributes: [NSAttributedStringKey: Any] = [NSAttributedStringKey.foregroundColor: PaletteColors.darkGray,
                                                                 NSAttributedStringKey.font: UIFont.customFont(.robotoMediumFont(size: 17))]
        guard let navigationBar = navigationController?.navigationBar else { return }
        navigationBar.titleTextAttributes = titleTextAttributes
        title = presentationModel.title
        
        let backButtonItem = UIBarButtonItem(title: nil, style: .plain, target: self, action: #selector(backButtonTapped))
        backButtonItem.image = UIImage(named: Constants.backImage)
        backButtonItem.tintColor = PaletteColors.darkGray
        navigationItem.leftBarButtonItem = backButtonItem
        navigationController?.interactivePopGestureRecognizer?.delegate = nil
    }
    
    private func configureCollectionView() {
        collectionView?.backgroundColor = .clear
        collectionView?.register(UINib(nibName: Constants.userCellId, bundle: nil), forCellWithReuseIdentifier: Constants.userCellId)
        collectionView?.register(UINib(nibName: Constants.gamesCellId, bundle: nil), forCellWithReuseIdentifier: Constants.gamesCellId)
        collectionView?.register(UINib(nibName: Constants.cupsCellId, bundle: nil), forCellWithReuseIdentifier: Constants.cupsCellId)
        
        guard let flowLayout = collectionView?.collectionViewLayout as? UICollectionViewFlowLayout else { return }
        flowLayout.estimatedItemSize.width = view.frame.width
        flowLayout.estimatedItemSize.height = LayoutConstants.estimatedCellHeight
    }
    
    @objc private func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
    
    // MARK: - CellForItemAt Methods
    
    private func userCell(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cellIdentifier = Constants.userCellId
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as? UserCell,
            let viewModel = presentationModel.userViewModel else {
                return UICollectionViewCell()
        }
        cell.configure(for: viewModel)
        cell.configureCellWidth(view.frame.width)
        cell.configureImage()
        return cell
    }
    
    private func gamesCell(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cellIdentifier = Constants.gamesCellId
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as? GamesAchievementsCell,
            let viewModel = presentationModel.userViewModel else {
                return UICollectionViewCell()
        }
        cell.configure(for: viewModel)
        cell.configureCellWidth(view.frame.width)
        return cell
    }
    
    private func cupsCell(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cellIdentifier = Constants.cupsCellId
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as? CupsAchievementsCell else { return UICollectionViewCell() }
        let achievement = presentationModel.userViewModel.achievements[indexPath.row]
        cell.configure(for: achievement)
        cell.configureCellWidth(view.frame.width)
        return cell
    }
    
}

// MARK: - UICollectionViewDelegateFlowLayout

extension AchievementsViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        if section == 0 {
            return UIEdgeInsets(top: LayoutConstants.topEdge, left: 0, bottom: 0, right: 0)
        } else {
            return UIEdgeInsets(top: 0, left: 0, bottom: LayoutConstants.bottomEdge, right: 0)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return LayoutConstants.cellSpacing
    }
}
