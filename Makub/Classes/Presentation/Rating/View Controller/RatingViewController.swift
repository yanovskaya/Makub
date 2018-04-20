//
//  RatingViewController.swift
//  Makub
//
//  Created by Елена Яновская on 20.03.2018.
//  Copyright © 2018 Elena Yanovskaya. All rights reserved.
//

import PKHUD
import UIKit

final class RatingViewController: UIViewController {
    
    // MARK: - Constants
    
    private enum Constants {
        static let title = "Рейтинг"
        static let common = "Общий"
        static let classic = "КУБ"
        static let fast = "БУБ"
        static let veryFast = "ББП"
        
        static let cellIdentifier = String(describing: RatingCell.self)
    }
    
    private enum LayoutConstants {
        static let leadingMargin: CGFloat = 5
        static let topEdge: CGFloat = 8
        static let bottomEdge: CGFloat = 10
        static let cellSpacing: CGFloat = 3
    }
    
    // MARK: - IBOutlets
    
    @IBOutlet private var navigationBar: UINavigationBar!
    @IBOutlet private var indicatorView: UIView!
    @IBOutlet private var commonButton: UIButton!
    @IBOutlet private var classicButton: UIButton!
    @IBOutlet private var fastButton: UIButton!
    @IBOutlet private var veryFastButton: UIButton!
    @IBOutlet private var ratingCollectionView: UICollectionView!
    
    @IBOutlet private var indicatorButtonLeadingConstraint: NSLayoutConstraint!
    
    // MARK: - Private Properties
    
    private var presentationModel = RatingPresentationModel()
    private var refreshControl = UIRefreshControl()
    private var ratingType: RatingType = .common
    
    // MARK: - ViewController lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = PaletteColors.blueBackground
        
        configureNavigationBar()
        configureCollectionView()
        configureIndicatorView()
        configureButtons()
        bindEventsRating()
        presentationModel.obtainRatingWithUser()
        
        let rightSwipe = UISwipeGestureRecognizer(target: self, action: #selector(swipeRight))
        rightSwipe.direction = UISwipeGestureRecognizerDirection.right
        ratingCollectionView.addGestureRecognizer(rightSwipe)
        
        let leftSwipe = UISwipeGestureRecognizer(target: self, action: #selector(swipeLeft))
        leftSwipe.direction = UISwipeGestureRecognizerDirection.left
        ratingCollectionView.addGestureRecognizer(leftSwipe)
    }
    
    @objc func swipeLeft() {
        indicatorButtonLeadingConstraint.isActive = false
        var const: CGFloat
        var button: UIButton
        switch ratingType {
        case .common:
            const = classicButton.frame.origin.x
            button = classicButton
            ratingType = .classic
        case .classic:
            const = fastButton.frame.origin.x
            button = fastButton
            ratingType = .fast
        case .fast:
            const = veryFastButton.frame.origin.x
            button = veryFastButton
            ratingType = .veryFast
        case .veryFast:
            return
        }
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 20, animations: ({
            self.indicatorView.frame.origin.x = const + 12
            
            self.commonButton.tintColor = PaletteColors.lightGray
            self.classicButton.tintColor = PaletteColors.lightGray
            self.fastButton.tintColor = PaletteColors.lightGray
            self.veryFastButton.tintColor = PaletteColors.lightGray
            button.tintColor = PaletteColors.blueTint
            self.bindEventsSort()
            self.presentationModel.sortRating(for: self.ratingType)
        }))
    }
    
    @objc func swipeRight() {
        indicatorButtonLeadingConstraint.isActive = false
        var const: CGFloat
        var button: UIButton
        switch ratingType {
        case .fast:
            const = classicButton.frame.origin.x
            button = classicButton
            ratingType = .classic
        case .veryFast:
            const = fastButton.frame.origin.x
            button = fastButton
            ratingType = .fast
        case .classic:
            const = commonButton.frame.origin.x
            button = commonButton
            ratingType = .common
        case .common:
            return
        }
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 20, animations: ({
            self.indicatorView.frame.origin.x = const + 12
            
            self.commonButton.tintColor = PaletteColors.lightGray
            self.classicButton.tintColor = PaletteColors.lightGray
            self.fastButton.tintColor = PaletteColors.lightGray
            self.veryFastButton.tintColor = PaletteColors.lightGray
            button.tintColor = PaletteColors.blueTint
            self.bindEventsSort()
            self.presentationModel.sortRating(for: self.ratingType)
        }))
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        tabBarController?.delegate = self
        if presentationModel.ratingViewModels.isEmpty {
            bindEventsRating()
            presentationModel.obtainRatingWithUser()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        HUD.hide()
    }
    
    // MARK: - Private Methods
    
    private func bindEventsRating() {
        presentationModel.changeStateHandler = { [weak self] status in
            switch status {
            case .loading:
                PKHUD.sharedHUD.dimsBackground = false
                PKHUD.sharedHUD.userInteractionOnUnderlyingViewsEnabled = true
                HUD.show(.progress)
            case .rich:
                self?.ratingCollectionView.reloadData()
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
    
    private func bindEventsRefreshRating() {
        presentationModel.changeStateHandler = { [weak self] status in
            switch status {
            case .loading:
                break
            case .rich:
                self?.ratingCollectionView.reloadData()
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
    
    private func bindEventsSort() {
        presentationModel.changeStateHandler = { [weak self] status in
            switch status {
            case .rich:
                self?.ratingCollectionView.reloadData()
                self?.scrollToTop()
                HUD.hide()
            default:
                break
            }
        }
    }
    
    // MARK: - Private Methods
    
    private func configureNavigationBar() {
        navigationController?.isNavigationBarHidden = true
        let titleTextAttributes: [NSAttributedStringKey: Any] = [NSAttributedStringKey.foregroundColor: PaletteColors.darkGray,
                                                                 NSAttributedStringKey.font: UIFont.customFont(.robotoMediumFont(size: 17))]
        navigationBar.titleTextAttributes = titleTextAttributes
        navigationBar.topItem?.title = Constants.title
        navigationBar.shadowImage = UIImage(color: UIColor.white)
        navigationBar.setBackgroundImage(UIImage(color: UIColor.white), for: .default)
    }
    
    private func configureCollectionView() {
        ratingCollectionView.backgroundColor = .clear
        ratingCollectionView.dataSource = self
        ratingCollectionView.delegate = self
        ratingCollectionView.register(UINib(nibName: Constants.cellIdentifier, bundle: nil), forCellWithReuseIdentifier: Constants.cellIdentifier)
        ratingCollectionView.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(refreshRating(_:)), for: .valueChanged)
        
        guard let flowLayout = ratingCollectionView.collectionViewLayout as? UICollectionViewFlowLayout else { return }
        flowLayout.estimatedItemSize.width = view.frame.width - 2 * LayoutConstants.leadingMargin
    }
    
    private func configureIndicatorView() {
        indicatorView.backgroundColor = PaletteColors.blueTint
        indicatorView.clipsToBounds = true
        indicatorView.layer.cornerRadius = 5
        indicatorView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
    }
    
    private func configureButtons() {
        commonButton.setTitle(Constants.common, for: .normal)
        classicButton.setTitle(Constants.classic, for: .normal)
        fastButton.setTitle(Constants.fast, for: .normal)
        veryFastButton.setTitle(Constants.veryFast, for: .normal)
        
        commonButton.tintColor = PaletteColors.blueTint
        classicButton.tintColor = PaletteColors.lightGray
        fastButton.tintColor = PaletteColors.lightGray
        veryFastButton.tintColor = PaletteColors.lightGray
        
        commonButton.tag = 0
        classicButton.tag = 1
        fastButton.tag = 2
        veryFastButton.tag = 3
    }
    
    private func scrollToTop() {
        let topPoint = CGPoint(x: 0, y: 0)
        ratingCollectionView.setContentOffset(topPoint, animated: true)
    }
    
    @objc private func refreshRating(_ refreshControl: UIRefreshControl) {
        bindEventsRefreshRating()
        presentationModel.refreshRating(type: ratingType)
    }
    
    // MARK: - IBAction
    
    @IBAction private func typeButtonTapped(_ sender: UIButton) {
        indicatorButtonLeadingConstraint.isActive = false
        var const: CGFloat
        var button: UIButton
        switch sender.tag {
        case 1:
            const = classicButton.frame.origin.x
            button = classicButton
            ratingType = .classic
        case 2:
            const = fastButton.frame.origin.x
            button = fastButton
            ratingType = .fast
        case 3:
            const = veryFastButton.frame.origin.x
            button = veryFastButton
            ratingType = .veryFast
        default:
            const = commonButton.frame.origin.x
            button = commonButton
            ratingType = .common
        }
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 20, animations: ({
            self.indicatorView.frame.origin.x = const + 12
            
            self.commonButton.tintColor = PaletteColors.lightGray
            self.classicButton.tintColor = PaletteColors.lightGray
            self.fastButton.tintColor = PaletteColors.lightGray
            self.veryFastButton.tintColor = PaletteColors.lightGray
            button.tintColor = PaletteColors.blueTint
            self.bindEventsSort()
            self.presentationModel.sortRating(for: self.ratingType)
        }))
    }
}

// MARK: - UICollectionViewDataSource

extension RatingViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return presentationModel.ratingViewModels.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let viewModel = presentationModel.ratingViewModels[indexPath.row]
        let cellIdentifier = Constants.cellIdentifier
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as? RatingCell else { return UICollectionViewCell() }
        cell.type = ratingType
        cell.ratingPosition = indexPath.row + 1
        if let userViewModel = presentationModel.userViewModel,
            viewModel.id == userViewModel.id {
            cell.isUserRating = true
        } else {
            cell.isUserRating = false
        }
        cell.configureCellWidth(view.frame.width)
        cell.configure(for: viewModel)
        cell.layoutIfNeeded()
        return cell
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension RatingViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: LayoutConstants.topEdge, left: 0, bottom: LayoutConstants.bottomEdge, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return LayoutConstants.cellSpacing
    }
}

// MARK: - UITabBarControllerDelegate

extension RatingViewController: UITabBarControllerDelegate {
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        if tabBarController.selectedIndex == 1 {
            scrollToTop()
        }
    }
}
