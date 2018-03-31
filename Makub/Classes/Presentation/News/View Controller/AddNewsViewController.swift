//
//  AddNewsViewController.swift
//  Makub
//
//  Created by Елена Яновская on 29.03.2018.
//  Copyright © 2018 Elena Yanovskaya. All rights reserved.
//

import FDTake
import Photos
import UIKit

final class AddNewsViewController: UIViewController {
    
    // MARK: - Constants
    
    private enum Constants {
        static let title = "Новости"
        static let leftButtonItem = "Отмена"
        static let rigthButtonItem = "Готово"
        static let titleTextField = "Название..."
        
        static let attachButton = "paperclip"
    }
    
    // MARK: - IBOutlets
    
    @IBOutlet private var navigationBar: UINavigationBar!
    @IBOutlet private var leftButtonItem: UIBarButtonItem!
    @IBOutlet private var rightButtonItem: UIBarButtonItem!
    
    @IBOutlet private var attachButton: UIButton!
    
    
    @IBOutlet private var newsTextView: UITextView!
    @IBOutlet private var titleTextField: UITextField!
    
    @IBOutlet private var heightTextView: NSLayoutConstraint!
    
    // MARK: - Private Properties
    
    private var fdTakeController = FDTakeController()
    private var imageToAttach: UIImage!
    
    // MARK: - ViewController lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = Constants.title
        view.backgroundColor = .white
        
        configureNavigationItems()
        configureFdTakeController()
        configureAttachButton()
        configureTextView()
        configureTextField()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        newsTextView.text = ""
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
                                               NSAttributedStringKey.font: UIFont.customFont(.robotoBoldFont(size: 17))], for: .normal)
        
        rightButtonItem.setTitleTextAttributes([NSAttributedStringKey.font: UIFont.customFont(.robotoBoldFont(size: 17))], for: .disabled)
        
        rightButtonItem.isEnabled = false
    }
    
    private func configureTextView() {
        newsTextView.textContainerInset = UIEdgeInsets(top: 10, left: 20, bottom: 20, right: 20)
        newsTextView.font = UIFont.customFont(.robotoRegularFont(size: 17))
        newsTextView.becomeFirstResponder()
        newsTextView.delegate = self
        newsTextView.target(forAction: #selector(editingChanged), withSender: self)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: .UIKeyboardWillShow, object: nil)
    }
    
    private func configureTextField() {
        titleTextField.delegate = self
        titleTextField.backgroundColor = .clear
        titleTextField.placeholder = Constants.titleTextField
        titleTextField.font = UIFont.customFont(.robotoBoldFont(size: 18))
    }
    
    private func configureAttachButton() {
        attachButton.setImage(UIImage(named: Constants.attachButton), for: .normal)
        attachButton.setTitle("", for: .normal)
    }
    
    private func configureFdTakeController() {
        fdTakeController.didGetPhoto = {
            (photo, _) in
            self.imageToAttach = photo
            self.attachButton.tintColor = .green
        }
        fdTakeController.allowsVideo = false
    }
    
    @objc private func keyboardWillShow(_ notification: Notification) {
        if let keyboardFrame: NSValue = notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            let keyboardTopPoint = keyboardRectangle.minY
            heightTextView.constant = keyboardTopPoint - newsTextView.frame.minY
        }
    }
    
    @objc private func editingChanged() {
        guard let text = newsTextView.text, text.count > 2
            else {
                rightButtonItem.isEnabled = false
                return
        }
        rightButtonItem.isEnabled = true
    }
    
    // MARK: - IBActions
    
    @IBAction private func leftButtonItemTapped(_ sender: Any) {
        dismiss(animated: true)
        titleTextField.resignFirstResponder()
        newsTextView.resignFirstResponder()
    }
    
    @IBAction func rightButtonItemTapped(_ sender: Any) {
//        titleTextField.resignFirstResponder()
//        newsTextView.resignFirstResponder()
    }
    
    
    @IBAction func attachButtonTapped(_ sender: Any) {
        fdTakeController.present()
    }
    
}

// MARK: - UITextFieldDelegate

extension AddNewsViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.text = textField.text?.removeBlankText()
        textField.resignFirstResponder()
        newsTextView.becomeFirstResponder()
        return false
    }
}

// MARK: - UITextViewDelegate

extension AddNewsViewController: UITextViewDelegate {
    
    func textViewDidChange(_ textView: UITextView) {
        guard let text = textView.text else {
            rightButtonItem.isEnabled = false
            return
        }
        rightButtonItem.isEnabled = !text.removeBlankText().isEmpty
    }
}
