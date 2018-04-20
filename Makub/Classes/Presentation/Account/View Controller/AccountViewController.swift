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
        static let settingsImage = "settings"
        static let userCellId = String(describing: UserCell.self)
        static let settingCellId = String(describing: SettingCell.self)
    }
    
    private enum LayoutConstants {
        static let leadingMargin: CGFloat = 5
        static let topEdge: CGFloat = 10
        static let bottomEdge: CGFloat = 10
        static let estimatedCellHeight: CGFloat = 114
    }
    
    let presentationModel = AccountPresentationModel()

    private var settingsAreObtained = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = PaletteColors.blueBackground
        collectionView?.backgroundColor = .clear
        navigationController?.isNavigationBarHidden = false
        
        collectionView?.register(UINib(nibName: Constants.userCellId, bundle: nil), forCellWithReuseIdentifier: Constants.userCellId)
        collectionView?.register(UINib(nibName: Constants.settingCellId, bundle: nil), forCellWithReuseIdentifier: Constants.settingCellId)
        
        let navigationBar = navigationController?.navigationBar
        navigationController?.navigationBar.shadowImage = UIImage(color: UIColor.white)
        navigationController?.navigationBar.setBackgroundImage(UIImage(color: UIColor.white), for: .default)
        navigationController?.navigationBar.isTranslucent = true
        let titleTextAttributes: [NSAttributedStringKey: Any] = [NSAttributedStringKey.foregroundColor: PaletteColors.darkGray,
                                                                 NSAttributedStringKey.font: UIFont.customFont(.robotoMediumFont(size: 17))]
        
        navigationBar?.titleTextAttributes = titleTextAttributes
        navigationBar?.topItem?.title = Constants.title
        let settingsButtonItem = UIBarButtonItem(title: nil, style: .plain, target: self, action: nil)
        settingsButtonItem.image = UIImage(named: Constants.settingsImage)
        settingsButtonItem.tintColor = PaletteColors.textGray
        
        navigationItem.rightBarButtonItem = settingsButtonItem
        
        guard let flowLayout = collectionView?.collectionViewLayout as? UICollectionViewFlowLayout else { return }
        flowLayout.estimatedItemSize.width = view.frame.width
        flowLayout.estimatedItemSize.height = LayoutConstants.estimatedCellHeight
        
        
        bindEvents()
        presentationModel.obtainProfileWithSettings()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        tabBarController?.delegate = self
    }
    
    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        if settingsAreObtained {
            return 2
        } else {
            return 0
        }
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else {
            return presentationModel.settingModels.count
        }
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if indexPath.section == 0 {
            let cellIdentifier = Constants.userCellId
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as? UserCell else { return UICollectionViewCell() }
    
        return cell
        } else {
            let cellIdentifier = Constants.settingCellId
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as? SettingCell else { return UICollectionViewCell() }
            if indexPath.row + 1 == presentationModel.settingModels.count {
                cell.configureSeperator(hide: true)
            }
            return cell
        }
    }
    
    private func bindEvents() {
        presentationModel.changeStateHandler = { [weak self] status in
            switch status {
            case .loading:
                PKHUD.sharedHUD.dimsBackground = false
                PKHUD.sharedHUD.userInteractionOnUnderlyingViewsEnabled = true
                HUD.show(.progress)
            case .rich:
                self?.settingsAreObtained = true
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
}

// MARK: - UICollectionViewDelegateFlowLayout

extension AccountViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        if section == 0 {
            return UIEdgeInsets(top: LayoutConstants.topEdge, left: 0, bottom: 0, right: 0)
        } else {
            return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
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
