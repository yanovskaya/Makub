//
//  AddNewsViewController.swift
//  Makub
//
//  Created by Елена Яновская on 29.03.2018.
//  Copyright © 2018 Elena Yanovskaya. All rights reserved.
//

import UIKit

final class AddNewsViewController: UIViewController {
    
    // MARK: - Constants
    
    private enum Constants {
        static let title = "Новости"
        static let leftButtonItem = "Отмена"
        static let rigthButtonItem = "Готово"
    }
    
    // MARK: - IBOutlets
    
    @IBOutlet private var navigationBar: UINavigationBar!
    @IBOutlet private var leftButtonItem: UIBarButtonItem!
    @IBOutlet private var rightButtonItem: UIBarButtonItem!
    
    // MARK: - ViewController lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = Constants.title
        configureNavigationItems()
    }
    
    // MARK: - Private Methods
    
    private func configureNavigationItems() {
        navigationBar.topItem?.title = Constants.title
        leftButtonItem.title = Constants.leftButtonItem
        rightButtonItem.title = Constants.rigthButtonItem
        
        navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: PaletteColors.darkGray,
                                             NSAttributedStringKey.font: UIFont.customFont(.robotoMediumFont(size: 17))]
        leftButtonItem.setTitleTextAttributes([NSAttributedStringKey.foregroundColor: PaletteColors.blueTint,
                                               NSAttributedStringKey.font: UIFont.customFont(.robotoRegularFont(size: 17))], for: .normal)
        rightButtonItem.setTitleTextAttributes([NSAttributedStringKey.foregroundColor: PaletteColors.blueTint,
                                                NSAttributedStringKey.font: UIFont.customFont(.robotoRegularFont(size: 17))], for: .normal)
        
        rightButtonItem.isEnabled = false
    }
    
    // MARK: - IBActions
    
    @IBAction private func leftButtonItemTapped(_ sender: Any) {
        dismiss(animated: true)
    }
    
}
