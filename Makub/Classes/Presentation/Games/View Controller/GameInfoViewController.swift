//
//  GameInfoViewController.swift
//  Makub
//
//  Created by Елена Яновская on 14.04.2018.
//  Copyright © 2018 Elena Yanovskaya. All rights reserved.
//

import PKHUD
import UIKit

final class GameInfoViewController: UIViewController {
    
    private enum Constants {
        static let title = "Об игре"
        static let backButtonImage = "arrow_left"
        
        static let gameInfoCellId = String(describing: GameInfoCell.self)
        static let addCommentCellId = String(describing: AddCommentCell.self)
        static let commentsCellId = String(describing: CommentsCell.self)
    }

    private enum LayoutConstants {
        static let topEdge: CGFloat = 5
        static let bottomEdge: CGFloat = 5
        static let cellSpacing: CGFloat = 3
    }
    
    // MARK: - IBOutlets
    
    @IBOutlet private var navBackgroundView: UIView!
    @IBOutlet private var navigationBar: UINavigationBar!
    @IBOutlet private var backButtonItem: UIBarButtonItem!
    @IBOutlet private var gameCollectionView: UICollectionView!
    
    // MARK: - Public Properties
    
    let presentationModel = GameInfoPresentationModel()
    
    // MARK: - Private Properties
    
    private let router = GamesRouter()
    
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
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        UIApplication.shared.statusBarView?.backgroundColor = .clear
        tabBarController?.delegate = self
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        HUD.hide()
    }
    
    override var prefersStatusBarHidden: Bool {
        return false
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
                self?.gameCollectionView.reloadData()
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
                self?.gameCollectionView.reloadData()
            default:
                break
            }
        }
    }
    
    private func configureNavigationBar() {
        navigationController?.interactivePopGestureRecognizer?.delegate = nil
        let titleTextAttributes: [NSAttributedStringKey: Any] = [NSAttributedStringKey.foregroundColor: PaletteColors.darkGray,
                                                                 NSAttributedStringKey.font: UIFont.customFont(.robotoMediumFont(size: 17))]
        navigationBar.titleTextAttributes = titleTextAttributes
        navigationBar.topItem?.title = Constants.title
        navigationBar.setBackgroundImage(UIImage(color: UIColor.white), for: .default)
        navigationBar.shadowImage = UIImage(color: .white)
        navBackgroundView.backgroundColor = .white
        backButtonItem.image = UIImage(named: Constants.backButtonImage)
        backButtonItem.tintColor = PaletteColors.darkGray
    }
    
    private func configureCollectionView() {
        gameCollectionView.delegate = self
        gameCollectionView.dataSource = self
        
        gameCollectionView.register(UINib(nibName: Constants.gameInfoCellId, bundle: nil), forCellWithReuseIdentifier: Constants.gameInfoCellId)
        gameCollectionView.register(UINib(nibName: Constants.commentsCellId, bundle: nil), forCellWithReuseIdentifier: Constants.commentsCellId)
        gameCollectionView.register(UINib(nibName: Constants.addCommentCellId, bundle: nil), forCellWithReuseIdentifier: Constants.addCommentCellId)
        gameCollectionView.backgroundColor = .clear
        
        guard let flowLayout = gameCollectionView.collectionViewLayout as? UICollectionViewFlowLayout else { return }
        flowLayout.estimatedItemSize.width = view.frame.width
    }
    
    // MARK: - IBAction
    
    @IBAction private func backButtonTapped(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
}

// MARK: - UICollectionViewDataSource

extension GameInfoViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
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
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 || section == 1 {
            return 1
        } else {
            return presentationModel.commentViewModels.count
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
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
            let gameViewModel = presentationModel.gameViewModel,
            let tournamentViewModel = presentationModel.tournamentViewModel,
            let gameInfoViewModel = presentationModel.gameInfoViewModel else {
                return UICollectionViewCell()
        }
        cell.contentView.isUserInteractionEnabled = false
        cell.configureCellWidth(view.frame.width)
        cell.configure(for: gameViewModel)
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
    
}

// MARK: - UICollectionViewDelegate

extension GameInfoViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.section == 1 {
            router.presentAddCommentVC(source: self)
        }
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension GameInfoViewController: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        if section == 0 {
            return UIEdgeInsets(top: LayoutConstants.topEdge, left: 0, bottom: LayoutConstants.bottomEdge, right: 0)
        } else if section != 1 {
            return UIEdgeInsets(top: 0, left: 0, bottom: LayoutConstants.bottomEdge, right: 0)
        } else {
            return UIEdgeInsets(top: 0, left: 0, bottom: LayoutConstants.cellSpacing, right: 0)
        }
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return LayoutConstants.cellSpacing
    }
}

// MARK: - UITabBarControllerDelegate

extension GameInfoViewController: UITabBarControllerDelegate {
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {}
}

// MARK: - AddCommentViewControllerDelegate

extension GameInfoViewController: AddCommentViewControllerDelegate {
    
    func addCommentToCollectionView() {
        bindEventsObtainOnlyComments()
        presentationModel.obtainOnlyComments()
    }
}
