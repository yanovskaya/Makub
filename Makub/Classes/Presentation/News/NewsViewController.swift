//
//  NewsViewController.swift
//  Makub
//
//  Created by Елена Яновская on 20.03.2018.
//  Copyright © 2018 Elena Yanovskaya. All rights reserved.
//

import UIKit

final class NewsViewController: UIViewController {
    
    // MARK: - IBOutlets
    
    @IBOutlet var fakeNavigationView: UIView!
    @IBOutlet var navigationSearchBar: UISearchBar!
    
    // MARK: - ViewController lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.isNavigationBarHidden = true
        configureFakeNavigationBar()

    }
    
    // MARK: - Private Methods
    
    private func configureFakeNavigationBar() {
        fakeNavigationView.backgroundColor = .white
        navigationSearchBar.backgroundImage = UIImage(color: .clear)
        view.backgroundColor = PaletteColors.blueBackground
        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).backgroundColor = PaletteColors.searchBar
    }

}
