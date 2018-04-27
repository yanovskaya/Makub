//
//  NewsViewController.swift
//  Makub
//
//  Created by Елена Яновская on 20.03.2018.
//  Copyright © 2018 Elena Yanovskaya. All rights reserved.
//

import HidingNavigationBar
import PKHUD
import UIKit

final class NewsViewController: UIViewController {

    // MARK: - Constants
    
    private enum Constants {
        static let searchBarPlaceholder = "Поиск"
        static let deleteAction = "Удалить"
        static let cancelAction = "Отмена"
        static let pkhudDeleteTitle = "Готово!"
        static let pkhudDeleteSubtitle = "Запись удалена"
        static let addNewsCellId = String(describing: AddNewsCell.self)
        static let newsCellId = String(describing: NewsCell.self)
    }
    
    private enum LayoutConstants {
        static let topEdge: CGFloat = 10
        static let bottomEdge: CGFloat = 10
        static let cellSpacing: CGFloat = 10
    }
    
    // MARK: - IBOutlets
    
    @IBOutlet private var newsCollectionView: UICollectionView!
    
    // MARK: - Public Properties
    
    let presentationModel = NewsPresentationModel()
    
    // MARK: - Private Properties
    
    private var navigationSearchBar = UISearchBar()
    private weak var hidingNavBarManager: HidingNavigationBarManager?
    
    private let refreshControl = UIRefreshControl()
    private let router = NewsRouter()
    
    private var filteredNews = [NewsViewModel]()
    
    // MARK: - ViewController lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        filteredNews = presentationModel.newsViewModels
        view.backgroundColor = PaletteColors.blueBackground
        
        configureNavigationController()
        configureCollectionView()
        configureNavigationSearchBar()
        configureSearchBar()
        
        hideSearchKeyboardWhenTappedAround()
        bindEventsObtainNewsWithUser()
        presentationModel.obtainNewsWithUser()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        hidingNavBarManager?.viewWillAppear(animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        tabBarController?.delegate = self
        if presentationModel.newsViewModels.isEmpty {
            bindEventsObtainNewsWithUser()
            presentationModel.obtainNewsWithUser()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        HUD.hide()
    }
    
    // MARK: - Private Methods
    
    private func bindEventsObtainNewsWithUser() {
        presentationModel.changeStateHandler = { [weak self] status in
            switch status {
            case .loading:
                PKHUD.sharedHUD.dimsBackground = false
                PKHUD.sharedHUD.userInteractionOnUnderlyingViewsEnabled = true
                HUD.show(.progress)
            case .rich:
                self?.filteredNews = (self?.presentationModel.newsViewModels)!
                if let searchText = self?.navigationSearchBar.text {
                    self?.filterNewsForSearchText(searchText: searchText)
                }
                self?.newsCollectionView.reloadData()
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
    
    private func bindEventsRefreshNews() {
        presentationModel.changeStateHandler = { [weak self] status in
            switch status {
            case .loading:
                break
            case .rich:
                self?.filteredNews = (self?.presentationModel.newsViewModels)!
                if let searchText = self?.navigationSearchBar.text {
                    self?.filterNewsForSearchText(searchText: searchText)
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                    self?.refreshControl.endRefreshing()
                }
                self?.newsCollectionView.reloadData()
            case .error:
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                    self?.refreshControl.endRefreshing()
                }
            }
        }
    }
    
    private func bindEventsDeleteNews() {
        presentationModel.changeStateHandler = { [weak self] status in
            switch status {
            case .loading:
                HUD.show(.progress)
            case .rich:
                self?.filteredNews = (self?.presentationModel.newsViewModels)!
                if let searchText = self?.navigationSearchBar.text {
                    self?.filterNewsForSearchText(searchText: searchText)
                }
                self?.newsCollectionView.reloadData()
                HUD.show(.labeledSuccess(title: Constants.pkhudDeleteTitle, subtitle: Constants.pkhudDeleteSubtitle))
                HUD.hide(afterDelay: 1.0)
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
    
    private func bindEventsObtainOnlyNews() {
        presentationModel.changeStateHandler = { [weak self] status in
            switch status {
            case .rich:
                self?.filteredNews = (self?.presentationModel.newsViewModels)!
                if let searchText = self?.navigationSearchBar.text {
                    self?.filterNewsForSearchText(searchText: searchText)
                }
                self?.newsCollectionView.reloadData()
            default:
                break
            }
        }
    }
    
    private func configureNavigationController() {
        navigationItem.titleView = navigationSearchBar
        navigationController?.navigationBar.shadowImage = UIImage(color: UIColor.white)
        navigationController?.navigationBar.setBackgroundImage(UIImage(color: UIColor.white), for: .default)
        
        hidingNavBarManager = HidingNavigationBarManager(viewController: self, scrollView: newsCollectionView)
        hidingNavBarManager?.refreshControl = refreshControl
    }
    
    private func configureNavigationSearchBar() {
        navigationSearchBar.backgroundImage = UIImage(color: .clear)
        navigationSearchBar.searchBarStyle = .minimal
        navigationSearchBar.placeholder = Constants.searchBarPlaceholder
    }
    
    private func configureSearchBar() {
        navigationSearchBar.delegate = self
        navigationSearchBar.tintColor = PaletteColors.blueTint
    }
    
    private func configureCollectionView() {
        newsCollectionView.dataSource = self
        newsCollectionView.delegate = self
        newsCollectionView.backgroundColor = .clear
        
        newsCollectionView.register(UINib(nibName: Constants.addNewsCellId, bundle: nil), forCellWithReuseIdentifier: Constants.addNewsCellId)
        newsCollectionView.register(UINib(nibName: Constants.newsCellId, bundle: nil), forCellWithReuseIdentifier: Constants.newsCellId)
        
        newsCollectionView.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(refreshGames(_:)), for: .valueChanged)
        guard let flowLayout = newsCollectionView.collectionViewLayout as? UICollectionViewFlowLayout else { return }
        flowLayout.estimatedItemSize.width = view.frame.width
        flowLayout.estimatedItemSize.height = 500
    }
    
    private func hideSearchKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissSearchKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    private func filterNewsForSearchText(searchText: String) {
        if searchText != "" {
            filteredNews = presentationModel.newsViewModels.filter { news in
                return (news.tag.contains(searchText.lowercased())
                    || news.title.lowercased().contains(searchText.lowercased())
                    || news.text.lowercased().contains(searchText.lowercased())
                    || news.fullName.lowercased().contains(searchText.lowercased()))
            }
        } else { filteredNews = presentationModel.newsViewModels }
        newsCollectionView.reloadData()
    }
    
    @objc private func dismissSearchKeyboard() {
        navigationSearchBar.setShowsCancelButton(false, animated: true)
        navigationSearchBar.resignFirstResponder()
    }
    
    @objc private func refreshGames(_ refreshControl: UIRefreshControl) {
        bindEventsRefreshNews()
        presentationModel.refreshNewsWithUser()
    }
}


// MARK: - UISearchBarDelegate

extension NewsViewController: UISearchBarDelegate {
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(true, animated: true)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        searchBar.setShowsCancelButton(false, animated: true)
        searchBar.resignFirstResponder()
        
        filteredNews = presentationModel.newsViewModels
        newsCollectionView.reloadData()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(false, animated: true)
        searchBar.resignFirstResponder()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filterNewsForSearchText(searchText: searchText)
    }
}


// MARK: - UICollectionViewDataSource

extension NewsViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else {
            return filteredNews.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let section = indexPath.section
        if section == 0 {
            return addNewsCell(collectionView, cellForItemAt: indexPath)
        } else {
            return newsCell(collectionView, cellForItemAt: indexPath)
        }
    }
    
    private func addNewsCell(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
         let cellIdentifier = Constants.addNewsCellId
        guard let cell =
            collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as? AddNewsCell else { return UICollectionViewCell() }
        let viewModel = presentationModel.userViewModel
        cell.configure(for: viewModel)
        cell.layoutIfNeeded()
        return cell
    }
    
    private func newsCell(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cellIdentifier = Constants.newsCellId
        guard let cell =
            collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as? NewsCell else { return UICollectionViewCell() }
        let viewModel = filteredNews[indexPath.row]
        cell.configureCellWidth(view.frame.width)
        cell.configure(for: viewModel)
        if let userViewModel = presentationModel.userViewModel {
            cell.configureMoreButton(userId: userViewModel.id)
        }
        cell.delegate = self
        cell.contentView.isUserInteractionEnabled = false
        cell.layoutIfNeeded()
        cell.updateConstraints()
        return cell
    }
    
}

// MARK: - UICollectionViewDelegate

extension NewsViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            router.presentAddNewsVC(source: self)
        }
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension NewsViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        if section == 0 {
            return UIEdgeInsets(top: LayoutConstants.topEdge, left: 0, bottom: 0, right: 0)
        } else {
            return UIEdgeInsets(top: LayoutConstants.topEdge, left: 0, bottom: LayoutConstants.bottomEdge, right: 0)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return LayoutConstants.cellSpacing
    }
    
    func scrollViewShouldScrollToTop(scrollView: UIScrollView) -> Bool {
        hidingNavBarManager?.shouldScrollToTop()
        return true
    }
}

// MARK: - UITabBarControllerDelegate

extension NewsViewController: UITabBarControllerDelegate {
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        if tabBarController.selectedIndex == 0 {
            let indexPath = IndexPath(item: 0, section: 0)
            hidingNavBarManager?.shouldScrollToTop()
            newsCollectionView.scrollToItem(at: indexPath, at: .top, animated: true)
        }
    }
}

// MARK: - NewsCellDelegate

extension NewsViewController: NewsCellDelegate {
    
    func moreButtonTapped(_ sender: NewsCell) {
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let deleteAction = UIAlertAction(title: Constants.deleteAction, style: .destructive) { _ in
            self.bindEventsDeleteNews()
            self.presentationModel.deleteNews(id: sender.tag)
        }
        let cancelAction = UIAlertAction(title: Constants.cancelAction, style: .cancel)
        
        alertController.addAction(deleteAction)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true, completion: nil)
    }
}

// MARK: - AddNewsViewControllerDelegate

extension NewsViewController: AddNewsViewControllerDelegate {
    
    func addNewsToCollectionView() {
        bindEventsObtainOnlyNews()
        presentationModel.obtainOnlyNews()
    }
}
