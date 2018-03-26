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
    
    @IBOutlet var fakeNavigationView: UIView!
    @IBOutlet var navigationSearchBar: UISearchBar!
    
    @IBOutlet var newsCollectionView: UICollectionView!
    
    
    // MARK: - Private Properties
    
    private let presentationModel = NewsPresentationModel()
    
    // MARK: - ViewController lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.isNavigationBarHidden = true
        view.backgroundColor = PaletteColors.blueBackground
        

        newsCollectionView.register(UINib(nibName: Constants.addNewsCellId, bundle: nil), forCellWithReuseIdentifier: Constants.addNewsCellId)
        newsCollectionView.register(UINib(nibName: Constants.newsCellId, bundle: nil), forCellWithReuseIdentifier: Constants.newsCellId)
        if let flowLayout = newsCollectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            flowLayout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 10, right: 0)
            flowLayout.estimatedItemSize = CGSize(width: 1, height: 1)
        }
       newsCollectionView.backgroundColor = .clear
        newsCollectionView.dataSource = self
        
        configureFakeNavigationBar()
        configureSearchBar()
        
        hideSearchKeyboardWhenTappedAround()
        bindEvents()
        presentationModel.obtainNews {
            print("result")
            print(self.presentationModel.tabBarViewModel?.photoURL)
        }
    }
    
    // MARK: - Private Methods
    
    private func bindEvents() {
        presentationModel.changeStateHandler = { status in
            switch status {
            case .loading:
                HUD.show(.progress)
            case .rich:
                self.newsCollectionView.reloadData()
                print("RELOAD")
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
                print("err")
                HUD.hide(afterDelay: 1.0)
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
    
    private func hideSearchKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissSearchKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    @objc private func dismissSearchKeyboard() {
        navigationSearchBar.setShowsCancelButton(false, animated: true)
        navigationSearchBar.resignFirstResponder()
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
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(false, animated: true)
        searchBar.resignFirstResponder()
    }
}


// MARK: - UITableViewDataSource

extension NewsViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else {
            return presentationModel.newsViewModels.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
     //   let newsViewModel = presentationModel.newsViewModels[indexPath.row]
        let section = indexPath.section
        let addNewsCellId = Constants.addNewsCellId
        let newsCellId = Constants.newsCellId
        
        let addNewsCell =
            newsCollectionView.dequeueReusableCell(withReuseIdentifier: addNewsCellId, for: indexPath) as! AddNewsCell
        let newsCell =
            newsCollectionView.dequeueReusableCell(withReuseIdentifier: newsCellId, for: indexPath) as! NewsCell

        if section == 0 {
            addNewsCell.widthAnchor.constraint(equalToConstant: view.frame.width).isActive = true
         //   addNewsCell.layoutIfNeeded()
            return addNewsCell
        } else {
            newsCell.widthAnchor.constraint(equalToConstant: view.frame.width).isActive = true
            let viewModel = presentationModel.newsViewModels[indexPath.row]
            newsCell.configure(for: viewModel)
        //    newsCell.layoutIfNeeded()
            return newsCell
        }
    }
    
}
