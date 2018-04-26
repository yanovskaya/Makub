//
//  AccountViewController.swift
//  Makub
//
//  Created by Елена Яновская on 20.04.2018.
//  Copyright © 2018 Elena Yanovskaya. All rights reserved.
//

import PKHUD
import UIKit

final class AccountViewController: UICollectionViewController {
    
    // MARK: - Constants
    
    private enum Constants {
        static let title = "Личный кабинет"
        static let exitAction = "Выйти"
        static let cancelAction = "Отмена"
        static let settingsImage = "settings"
        static let userCellId = String(describing: UserCell.self)
        static let settingCellId = String(describing: SettingCell.self)
        static let exitCellId = String(describing: ExitCell.self)
    }
    
    private enum LayoutConstants {
        static let leadingMargin: CGFloat = 5
        static let topEdge: CGFloat = 10
        static let bottomEdge: CGFloat = 10
        static let estimatedCellHeight: CGFloat = 114
    }
    
    // MARK: - Public Properties
    
    let presentationModel = AccountPresentationModel()
    
    // MARK: - Private Properties

    private let router = AccountRouter()
    
    // MARK: - ViewController lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = PaletteColors.blueBackground
        configureNavigationBar()
        configureCollectionView()
        bindEvents()
        presentationModel.obtainProfileWithSettings()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        tabBarController?.delegate = self
        if presentationModel.userViewModel == nil {
            bindEvents()
            presentationModel.obtainProfileWithSettings()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        HUD.hide()
    }
    
    // MARK: - UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        if presentationModel.userViewModel != nil {
            return 3
        } else {
            return 0
        }
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 || section == 2 {
            return 1
        } else {
            return presentationModel.settingModels.count
        }
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let section = indexPath.section
        if section == 0 {
            return userCell(collectionView, cellForItemAt: indexPath)
        } else if indexPath.section == 1 {
            return settingCell(collectionView, cellForItemAt: indexPath)
        } else {
            return exitCell(collectionView, cellForItemAt: indexPath)
        }
    }
    
    // MARK: - UICollectionViewDelegate
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let section = indexPath.section
        if section == 1 {
            settingCell(collectionView, didSelectItemAt: indexPath)
        } else if section == 2 {
            exitButtonSelected()
        }
    }
    
    // MARK: - Private Methods
    
    private func bindEvents() {
        presentationModel.changeStateHandler = { [weak self] status in
            switch status {
            case .loading:
                PKHUD.sharedHUD.dimsBackground = false
                PKHUD.sharedHUD.userInteractionOnUnderlyingViewsEnabled = true
                HUD.show(.progress)
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
            }
        }
    }
    
    private func configureNavigationBar() {
        navigationController?.isNavigationBarHidden = false
        let navigationBar = navigationController?.navigationBar
        navigationBar?.isTranslucent = false
        navigationBar?.shadowImage = UIImage(color: UIColor.white)
        navigationBar?.setBackgroundImage(UIImage(color: UIColor.white), for: .default)
        let titleTextAttributes: [NSAttributedStringKey: Any] = [NSAttributedStringKey.foregroundColor: PaletteColors.darkGray,
                                                                 NSAttributedStringKey.font: UIFont.customFont(.robotoMediumFont(size: 17))]
        navigationBar?.titleTextAttributes = titleTextAttributes
        navigationBar?.topItem?.title = Constants.title
        
        let settingsButtonItem = UIBarButtonItem(title: nil, style: .plain, target: self, action: #selector(settingsButtonItemTapped))
        settingsButtonItem.image = UIImage(named: Constants.settingsImage)
        settingsButtonItem.tintColor = PaletteColors.textGray
        navigationItem.rightBarButtonItem = settingsButtonItem
    }
    
    private func configureCollectionView() {
        collectionView?.backgroundColor = .clear
        collectionView?.register(UINib(nibName: Constants.userCellId, bundle: nil), forCellWithReuseIdentifier: Constants.userCellId)
        collectionView?.register(UINib(nibName: Constants.settingCellId, bundle: nil), forCellWithReuseIdentifier: Constants.settingCellId)
        collectionView?.register(UINib(nibName: Constants.exitCellId, bundle: nil), forCellWithReuseIdentifier: Constants.exitCellId)
        
        guard let flowLayout = collectionView?.collectionViewLayout as? UICollectionViewFlowLayout else { return }
        flowLayout.estimatedItemSize.width = view.frame.width
        flowLayout.estimatedItemSize.height = LayoutConstants.estimatedCellHeight
    }
    
    private func exitButtonSelected() {
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let deleteAction = UIAlertAction(title: Constants.exitAction, style: .destructive) { _ in
            self.router.exitToAuthorization()
        }
        let cancelAction = UIAlertAction(title: Constants.cancelAction, style: .cancel)
        
        alertController.addAction(deleteAction)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
    @objc private func settingsButtonItemTapped() {
        if presentationModel.userViewModel != nil {
            router.showEditProfileVC(source: self)
        }
    }
    
    // MARK: - CellForItemAt Methods
    
    private func userCell(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cellIdentifier = Constants.userCellId
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as? UserCell else { return UICollectionViewCell() }
        cell.configure(for: presentationModel.userViewModel)
        cell.configureCellWidth(view.frame.width)
        cell.configureImage(type: .unfilled)
        return cell
    }
    
    private func settingCell(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cellIdentifier = Constants.settingCellId
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as? SettingCell else { return UICollectionViewCell() }
        if indexPath.row + 1 == presentationModel.settingModels.count {
            cell.configureSeperator(isHidden: true)
        }
        cell.configure(for: presentationModel.settingModels[indexPath.row])
        return cell
    }
    
    private func exitCell(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cellIdentifier = Constants.exitCellId
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as? ExitCell else { return UICollectionViewCell() }
        return cell
    }
    
    // MARK: - didSelectItemAt Methods
    
    private func settingCell(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            router.showAchievementsVC(source: self, indexPath.row)
        case 1:
            router.showUserGamesVC(source: self, indexPath.row)
        default:
            router.showUserCommentsVC(source: self, indexPath.row)
        }
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension AccountViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        if section == 0 {
            return UIEdgeInsets(top: LayoutConstants.topEdge, left: 0, bottom: 0, right: 0)
        } else {
            return UIEdgeInsets(top: 0, left: 0, bottom: LayoutConstants.bottomEdge, right: 0)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}

// MARK: - UITabBarControllerDelegate

extension AccountViewController: UITabBarControllerDelegate {
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {}
}
