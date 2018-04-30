//
//  UserGameInfoViewController.swift
//  Makub
//
//  Created by Елена Яновская on 30.04.2018.
//  Copyright © 2018 Elena Yanovskaya. All rights reserved.
//

import PKHUD
import UIKit

final class UserGameInfoViewController: UICollectionViewController {
    
    private enum Constants {
        static let title = "Об игре"
        static let backButtonImage = "arrow_left"
        
        static let gameInfoCellId = String(describing: GameInfoCell.self)
        static let addCommentCellId = String(describing: AddCommentCell.self)
        static let commentsCellId = String(describing: CommentsCell.self)
    }
    
    private enum LayoutConstants {
        static let bottomEdge: CGFloat = 5
        static let cellSpacing: CGFloat = 3
    }

    // MARK: - Public Properties
    
    let presentationModel = UserGameInfoPresentationModel()
    
    // MARK: - Private Properties
    
    private let router = AccountRouter()
    
    private var gameInfoIsObtained = false
    
    // MARK: - ViewController lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = PaletteColors.blueBackground
        
        configureNavigationBar()
        configureCollectionView()
        
        bindEventsObtainGameInfo()
        presentationModel.obtainGame()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        HUD.hide()
    }

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        if gameInfoIsObtained {
            if presentationModel.commentViewModels.count == 0 {
                return 2
            } else {
                return 3
            }
        } else {
            return 0
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 || section == 1 {
            return 1
        } else {
            return presentationModel.commentViewModels.count
        }
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let section = indexPath.section
        if section == 0 {
            return gameInfoCell(collectionView, cellForItemAt: indexPath)
        } else if section == 1 {
            return addCommentCell(collectionView, cellForItemAt: indexPath)
        } else {
            return commentsCell(collectionView, cellForItemAt: indexPath)
        }
    }
    
    private func gameInfoCell(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cellIdentifier = Constants.gameInfoCellId
        guard let cell =
            collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as? GameInfoCell,
            let tournamentViewModel = presentationModel.tournamentViewModel,
            let gameInfoViewModel = presentationModel.gameInfoViewModel else {
                return UICollectionViewCell()
        }
        cell.contentView.isUserInteractionEnabled = false
        cell.configureCellWidth(view.frame.width)
        cell.configure(viewModel: gameInfoViewModel)
        cell.configureClubs(viewModel: gameInfoViewModel)
        cell.configureTournament(for: tournamentViewModel)
        cell.layoutIfNeeded()
        return cell
    }
    
    private func addCommentCell(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cellIdentifier = Constants.addCommentCellId
        guard let cell =
            collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as? AddCommentCell,
            let viewModel = presentationModel.userViewModel else {
                return UICollectionViewCell()
        }
        cell.configure(for: viewModel)
        cell.layoutIfNeeded()
        return cell
    }
    
    private func commentsCell(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cellIdentifier = Constants.commentsCellId
        guard let cell =
            collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as? CommentsCell else { return UICollectionViewCell() }
        let viewModel = presentationModel.commentViewModels[indexPath.row]
        cell.configure(for: viewModel)
        cell.configureCellWidth(view.frame.width)
        cell.layoutIfNeeded()
        return cell
    }
    
    // MARK: - UICollectionViewDelegate
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.section == 1 {
            router.presentAddCommentVC(source: self)
        }
    }

    // MARK: - Private Methods
    
    private func bindEventsObtainGameInfo() {
        presentationModel.changeStateHandler = { [weak self] status in
            switch status {
            case .loading:
                PKHUD.sharedHUD.dimsBackground = false
                PKHUD.sharedHUD.userInteractionOnUnderlyingViewsEnabled = true
                DispatchQueue.main.async {
                    HUD.show(.progress)
                }
            case .rich:
                self?.gameInfoIsObtained = true
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
    
    private func bindEventsObtainOnlyComments() {
        presentationModel.changeStateHandler = { [weak self] status in
            switch status {
            case .rich:
                self?.collectionView?.reloadData()
            default:
                break
            }
        }
    }
    
    private func configureNavigationBar() {
        navigationController?.interactivePopGestureRecognizer?.delegate = nil
        let titleTextAttributes: [NSAttributedStringKey: Any] = [NSAttributedStringKey.foregroundColor: PaletteColors.darkGray,
                                                                 NSAttributedStringKey.font: UIFont.customFont(.robotoMediumFont(size: 17))]
        let navigationBar = navigationController?.navigationBar
        let backButtonItem = UIBarButtonItem(title: nil, style: .plain, target: self, action: #selector(backButtonTapped))
        navigationItem.leftBarButtonItem = backButtonItem
        navigationBar?.titleTextAttributes = titleTextAttributes
        title = Constants.title
        navigationBar?.setBackgroundImage(UIImage(color: UIColor.white), for: .default)
        backButtonItem.image = UIImage(named: Constants.backButtonImage)
        backButtonItem.tintColor = PaletteColors.darkGray
    }
    
    private func configureCollectionView() {
        collectionView?.register(UINib(nibName: Constants.gameInfoCellId, bundle: nil), forCellWithReuseIdentifier: Constants.gameInfoCellId)
        collectionView?.register(UINib(nibName: Constants.commentsCellId, bundle: nil), forCellWithReuseIdentifier: Constants.commentsCellId)
        collectionView?.register(UINib(nibName: Constants.addCommentCellId, bundle: nil), forCellWithReuseIdentifier: Constants.addCommentCellId)
        collectionView?.backgroundColor = .clear
        
        guard let flowLayout = collectionView?.collectionViewLayout as? UICollectionViewFlowLayout else { return }
        flowLayout.estimatedItemSize.width = view.frame.width
    }
    
    @objc private func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }

}

// MARK: - UICollectionViewDelegateFlowLayout

extension UserGameInfoViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        if section != 1 {
            return UIEdgeInsets(top: 0, left: 0, bottom: LayoutConstants.bottomEdge, right: 0)
        } else {
            return UIEdgeInsets(top: 0, left: 0, bottom: LayoutConstants.cellSpacing, right: 0)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return LayoutConstants.cellSpacing
    }
}

// MARK: - AddCommentViewControllerDelegate

extension UserGameInfoViewController: AddCommentViewControllerDelegate {
    
    func addCommentToCollectionView() {
        bindEventsObtainOnlyComments()
        presentationModel.obtainOnlyComments()
    }
}
