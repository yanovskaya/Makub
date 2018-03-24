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
    }
    
    // MARK: - IBOutlets
    
    @IBOutlet var fakeNavigationView: UIView!
    @IBOutlet var navigationSearchBar: UISearchBar!
    
    @IBOutlet var userImageView: UIImageView!
    
    // MARK: - Private Properties
    
    private let presentationModel = NewsPresentationModel()
    
    // MARK: - ViewController lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.isNavigationBarHidden = true
        
        configureFakeNavigationBar()
        configureSearchBar()
        
        hideSearchKeyboardWhenTappedAround()
        bindEvents()
        presentationModel.obtainNews {
            print(self.presentationModel.viewModel?.photo)
        }
    }
    
    // MARK: - Private Methods
    
    private func bindEvents() {
        presentationModel.changeStateHandler = { status in
            switch status {
            case .loading:
                HUD.show(.progress)
            case .rich:
                print("here")
                HUD.show(.success)
                HUD.hide(afterDelay: 0.4)
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
