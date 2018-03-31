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
    
    @IBOutlet private var newsTextView: UITextView!
    @IBOutlet private var heightTextField: NSLayoutConstraint!
    
    // MARK: - ViewController lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        newsTextView.textContainerInset = UIEdgeInsets(top: 20, left: 30, bottom: 20, right: 30)
        newsTextView.font = UIFont.customFont(.robotoRegularFont(size: 16))
        title = Constants.title
        configureNavigationItems()
        newsTextView.becomeFirstResponder()
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: .UIKeyboardWillShow, object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        viewWillAppear(animated)
        newsTextView.resignFirstResponder()
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        newsTextView.text = ""
    }
    
    @objc func keyboardWillShow(_ notification: Notification) {
        if let keyboardFrame: NSValue = notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            let keyboardHeight = keyboardRectangle.minY
            heightTextField.constant = keyboardHeight - newsTextView.frame.minY
        }
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
