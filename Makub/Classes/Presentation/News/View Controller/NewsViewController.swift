//
//  NewsViewController.swift
//  Makub
//
//  Created by Елена Яновская on 20.03.2018.
//  Copyright © 2018 Elena Yanovskaya. All rights reserved.
//

import PKHUD
import UIKit

final class NewsViewController: UIViewController {
    
    // MARK: - Constants
    
    private enum Constants {
        static let searchBarPlaceholder = "Поиск"
        static let addNewsCellId = String(describing: AddNewsCell.self)
        static let newsCellId = String(describing: NewsCell.self)
    }
    
    // MARK: - IBOutlets
    
    @IBOutlet private var fakeNavigationView: UIView!
    @IBOutlet private var navigationSearchBar: UISearchBar!
    @IBOutlet private var newsCollectionView: UICollectionView!
    
    
    // MARK: - Private Properties
    
    private let refreshControl = UIRefreshControl()
    private let presentationModel = NewsPresentationModel()
    private let router = NewsRouter()
    
    private var filteredNews = [NewsViewModel]()
    
    // MARK: - ViewController lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        filteredNews = presentationModel.newsViewModels
        navigationController?.isNavigationBarHidden = true
        view.backgroundColor = PaletteColors.blueBackground
        
        configureCollectionView()
        configureFakeNavigationBar()
        configureSearchBar()
        
        hideSearchKeyboardWhenTappedAround()
        bindEvents()
        presentationModel.obtainNews()
    }
    
    // MARK: - Private Methods
    
    private func bindEvents() {
        presentationModel.changeStateHandler = { status in
            switch status {
            case .loading:
                HUD.show(.progress)
            case .rich:
                self.filteredNews = self.presentationModel.newsViewModels
                if let searchText = self.navigationSearchBar.text {
                    self.filterNewsForSearchText(searchText: searchText)
                }
                self.newsCollectionView.reloadData()
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
                self.refreshControl.endRefreshing()
            }
        }
    }
    private func configureFakeNavigationBar() {
        fakeNavigationView.backgroundColor = .white
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
        refreshControl.addTarget(self, action: #selector(refresh(_:)), for: .valueChanged)
        
        guard let flowLayout = newsCollectionView.collectionViewLayout as? UICollectionViewFlowLayout else { return }
        flowLayout.estimatedItemSize = UICollectionViewFlowLayoutAutomaticSize
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
    
    @objc func refresh(_ refreshControl: UIRefreshControl) {
        presentationModel.refreshNews()
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
            let addNewsCellId = Constants.addNewsCellId
            guard let addNewsCell =
                newsCollectionView.dequeueReusableCell(withReuseIdentifier: addNewsCellId, for: indexPath) as? AddNewsCell else { return UICollectionViewCell() }
            let viewModel = presentationModel.userViewModel
            addNewsCell.configure(for: viewModel)
            return addNewsCell
        } else {
            let newsCellId = Constants.newsCellId
            guard let newsCell =
                newsCollectionView.dequeueReusableCell(withReuseIdentifier: newsCellId, for: indexPath) as? NewsCell else { return UICollectionViewCell() }
            let viewModel = filteredNews[indexPath.row]
            newsCell.configure(for: viewModel)
            return newsCell
        }
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
            return UIEdgeInsets(top: 10, left: 0, bottom: 0, right: 0)
        } else {
            return UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 0)
        }
    }
}
