//
//  AddNewsViewController.swift
//  Makub
//
//  Created by Елена Яновская on 29.03.2018.
//  Copyright © 2018 Elena Yanovskaya. All rights reserved.
//

import FDTake
import UIKit

final class AddNewsViewController: UIViewController {
    
    // MARK: - Constants
    
    private enum Constants {
        static let title = "Новости"
        static let leftButtonItem = "Отмена"
        static let rigthButtonItem = "Готово"
        
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
    
    var fdTakeController = FDTakeController()
    var imageToAttach: UIImage!
    
    // MARK: - ViewController lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fdTakeController.didGetPhoto = {
            (photo: UIImage, _) in
            print("GET")
            self.imageToAttach = photo
        }
        fdTakeController.allowsVideo = false
        
        title = Constants.title
        view.backgroundColor = .white
        
        configureNavigationItems()
        
        attachButton.setImage(UIImage(named: Constants.attachButton), for: .normal)
        attachButton.setTitle("", for: .normal)
        titleTextField.delegate = self
        titleTextField.backgroundColor = .clear
        titleTextField.placeholder = "Название..."
        configureTextView()
        
        newsTextView.target(forAction: #selector(editingChanged), withSender: self)
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
        let indentView = UIView(frame: CGRect(x: 0, y: 0, width: 25, height: 0))
        titleTextField.leftView = indentView
        titleTextField.leftViewMode = .always
        newsTextView.textContainerInset = UIEdgeInsets(top: 10, left: 20, bottom: 20, right: 20)
        titleTextField.font = UIFont.customFont(.robotoBoldFont(size: 18))
        newsTextView.font = UIFont.customFont(.robotoRegularFont(size: 17))
        newsTextView.becomeFirstResponder()
        newsTextView.delegate = self
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: .UIKeyboardWillShow, object: nil)
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
        newsTextView.resignFirstResponder()
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
