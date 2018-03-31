//
//  AddNewsViewController.swift
//  Makub
//
//  Created by Елена Яновская on 29.03.2018.
//  Copyright © 2018 Elena Yanovskaya. All rights reserved.
//

import FDTake
import Photos
import PKHUD
import UIKit

final class AddNewsViewController: UIViewController {
    
    // MARK: - Constants
    
    private enum Constants {
        static let title = "Новости"
        static let leftButtonItem = "Отмена"
        static let rigthButtonItem = "Готово"
        static let titleTextField = "Название..."
        static let pkhudTitle = "Подождите"
        static let pkhudSubtitle = "Публикуем новость"
        
        static let attachButton = "paperclip"
        static let removeButton = "close"
    }
    
    // MARK: - IBOutlets
    
    @IBOutlet private var navigationBar: UINavigationBar!
    @IBOutlet private var leftButtonItem: UIBarButtonItem!
    @IBOutlet private var rightButtonItem: UIBarButtonItem!
    
    @IBOutlet private var attachButton: UIButton!
    @IBOutlet private var removeButton: UIButton!
    
    @IBOutlet private var newsTextView: UITextView!
    @IBOutlet private var titleTextField: UITextField!
    
    @IBOutlet private var heightTextView: NSLayoutConstraint!
    @IBOutlet private var removeButtonHeight: NSLayoutConstraint!
    
    // MARK: - Private Properties
    
    private let presentationModel = NewsPresentationModel()
    
    private var fdTakeController = FDTakeController()
    
    private var imageToAttach: UIImage? {
        didSet {
            if imageToAttach != nil {
                attachButton.tintColor = UIColor.green
                removeButton.removeConstraint(removeButtonHeight)
                removeButton.setImage(UIImage(named: Constants.removeButton), for: .normal)
            } else {
                attachButton.tintColor = PaletteColors.darkGray
                removeButton.setImage(nil, for: .normal)
                removeButton.addConstraint(removeButtonHeight)
            }
        }
    }
    
    // MARK: - ViewController lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = Constants.title
        view.backgroundColor = .white
        
        configureNavigationItems()
        configureFdTakeController()
        configureRemoveButton()
        configureAttachButton()
        configureTextView()
        configureTextField()
        
        bindEvents()
    }
    
    // MARK: - Private Methods
    
    private func bindEvents() {
        presentationModel.changeStateHandler = { status in
            switch status {
            case .loading:
                PKHUD.sharedHUD.dimsBackground = true
                PKHUD.sharedHUD.userInteractionOnUnderlyingViewsEnabled = false
                HUD.show(.labeledProgress(title: Constants.pkhudTitle, subtitle: Constants.pkhudSubtitle))
            case .rich:
                HUD.show(.success)
                HUD.hide(afterDelay: 0.4)
                self.newsTextView.becomeFirstResponder()
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
                self.newsTextView.becomeFirstResponder()
            }
        }
    }
    
    private func configureNavigationItems() {
        navigationBar.topItem?.title = Constants.title
        leftButtonItem.title = Constants.leftButtonItem
        rightButtonItem.title = Constants.rigthButtonItem
        
        let titleTextAttributes: [NSAttributedStringKey: Any] = [NSAttributedStringKey.foregroundColor: PaletteColors.darkGray,
                                   NSAttributedStringKey.font: UIFont.customFont(.robotoMediumFont(size: 17))]
        
        let leftButtonAttributes = [NSAttributedStringKey.foregroundColor: PaletteColors.blueTint,
                                                                      NSAttributedStringKey.font: UIFont.customFont(.robotoRegularFont(size: 17))]
        let rightButtonAttributes = [NSAttributedStringKey.foregroundColor: PaletteColors.blueTint,
                                     NSAttributedStringKey.font: UIFont.customFont(.robotoBoldFont(size: 17))]
        navigationBar.titleTextAttributes = titleTextAttributes
        leftButtonItem.setTitleTextAttributes(leftButtonAttributes, for: .normal)
        leftButtonItem.setTitleTextAttributes(leftButtonAttributes, for: .selected)
        
        rightButtonItem.setTitleTextAttributes(rightButtonAttributes, for: .normal)
        rightButtonItem.setTitleTextAttributes(rightButtonAttributes, for: .selected)
        
        rightButtonItem.setTitleTextAttributes([NSAttributedStringKey.font: UIFont.customFont(.robotoBoldFont(size: 17))], for: .disabled)
        
        rightButtonItem.isEnabled = false
    }
    
    private func configureTextView() {
        newsTextView.textContainerInset = UIEdgeInsets(top: 10, left: 20, bottom: 20, right: 20)
        newsTextView.font = UIFont.customFont(.robotoRegularFont(size: 17))
        newsTextView.textColor = PaletteColors.darkGray
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
        titleTextField.textColor = PaletteColors.darkGray
    }
    
    private func configureAttachButton() {
        attachButton.setImage(UIImage(named: Constants.attachButton), for: .normal)
        attachButton.tintColor = PaletteColors.darkGray
        attachButton.setTitle("", for: .normal)
    }
    
    private func configureRemoveButton() {
        removeButton.tintColor = .lightGray
        removeButton.setTitle("", for: .normal)
    }
    
    private func configureFdTakeController() {
        fdTakeController.allowsVideo = false
        fdTakeController.didGetPhoto = { [unowned self] (photo, _) in
            self.imageToAttach = photo
        }
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
        view.endEditing(true)
    }
    
    @IBAction func rightButtonItemTapped(_ sender: Any) {
        view.endEditing(true)
        guard let title = titleTextField.text,
            let text = newsTextView.text else { return }
        if let image = self.imageToAttach {
            print("SEND WITH IMAGE")
            self.presentationModel.addNewsWithImage(title: title, text: text, image: image) {
                self.titleTextField.text = ""
                self.newsTextView.text = ""
                self.imageToAttach = nil
                self.rightButtonItem.isEnabled = false
            }
        } else {
            print("SEND NO IMAGE")
            self.presentationModel.addNews(title: title, text: text) {
                self.titleTextField.text = ""
                self.newsTextView.text = ""
                self.imageToAttach = nil
                self.rightButtonItem.isEnabled = false
            }
        }
    }
    
    
    @IBAction func attachButtonTapped(_ sender: Any) {
        fdTakeController.present()
    }
    
    @IBAction func removeButtonTapped(_ sender: Any) {
        imageToAttach = nil
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
