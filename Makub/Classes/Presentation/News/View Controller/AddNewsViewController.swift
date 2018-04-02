//
//  AddNewsViewController.swift
//  Makub
//
//  Created by Елена Яновская on 29.03.2018.
//  Copyright © 2018 Elena Yanovskaya. All rights reserved.
//

import FDTake
import Kingfisher
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
        
        static let cancel = "Отмена"
        static let noSources = "Нет доступных источников для выбора фото"
        static let chooseFromLibrary = "Выбрать из библиотеки"
        static let takePhoto = "Сфотографировать"
        
        static let attachButton = "paperclip"
        static let removeButton = "close"
        static let userImage = "user"
    }
    
    // MARK: - IBOutlets
    
    @IBOutlet private var navigationBar: UINavigationBar!
    @IBOutlet private var cancelButtonItem: UIBarButtonItem!
    @IBOutlet private var postButtonItem: UIBarButtonItem!
    
    @IBOutlet private var attachButton: UIButton!
    @IBOutlet private var removeButton: UIButton!
    
    @IBOutlet private var authorImageView: UIImageView!
    @IBOutlet private var authorLabel: UILabel!
    
    @IBOutlet private var previewImageView: UIImageView!
    @IBOutlet private var newsTextView: UITextView!
    @IBOutlet private var titleTextField: UITextField!
    
    @IBOutlet private var heightImageView: NSLayoutConstraint!
    @IBOutlet private var heightTextView: NSLayoutConstraint!
    @IBOutlet private var heightRemoveButton: NSLayoutConstraint!
    
    // MARK: - Public Properties
    
    var presentationModel: NewsPresentationModel!
    
    // MARK: - Private Properties
    
    private var fdTakeController = FDTakeController()
    
    private var imageToAttach: UIImage? {
        didSet {
            if imageToAttach != nil {
                attachButton.tintColor = UIColor.green
                removeButton.removeConstraint(heightRemoveButton)
                removeButton.setImage(UIImage(named: Constants.removeButton), for: .normal)
                previewImageView.image = imageToAttach
            } else {
                attachButton.tintColor = PaletteColors.darkGray
                removeButton.setImage(nil, for: .normal)
                removeButton.addConstraint(heightRemoveButton)
                previewImageView.image = nil
                newsTextView.becomeFirstResponder()
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
        configureAuthorView()
        
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
                print("SUCCESSS")
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
        cancelButtonItem.title = Constants.leftButtonItem
        postButtonItem.title = Constants.rigthButtonItem
        
        let titleTextAttributes: [NSAttributedStringKey: Any] = [NSAttributedStringKey.foregroundColor: PaletteColors.darkGray,
                                   NSAttributedStringKey.font: UIFont.customFont(.robotoMediumFont(size: 17))]
        
        let leftButtonAttributes = [NSAttributedStringKey.foregroundColor: PaletteColors.blueTint,
                                                                      NSAttributedStringKey.font: UIFont.customFont(.robotoRegularFont(size: 17))]
        let rightButtonAttributes = [NSAttributedStringKey.foregroundColor: PaletteColors.blueTint,
                                     NSAttributedStringKey.font: UIFont.customFont(.robotoBoldFont(size: 17))]
        navigationBar.titleTextAttributes = titleTextAttributes
        cancelButtonItem.setTitleTextAttributes(leftButtonAttributes, for: .normal)
        cancelButtonItem.setTitleTextAttributes(leftButtonAttributes, for: .selected)
        
        postButtonItem.setTitleTextAttributes(rightButtonAttributes, for: .normal)
        postButtonItem.setTitleTextAttributes(rightButtonAttributes, for: .selected)
        
        postButtonItem.setTitleTextAttributes([NSAttributedStringKey.font: UIFont.customFont(.robotoBoldFont(size: 17))], for: .disabled)
        
        postButtonItem.isEnabled = false
    }
    
    private func configureTextView() {
        newsTextView.textContainerInset = UIEdgeInsets(top: 5, left: 20, bottom: 10, right: 20)
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
    
    private func configureAuthorView() {
        authorImageView.image = UIImage(named: Constants.userImage)
        authorImageView.layer.cornerRadius = authorImageView.frame.width / 2
        authorImageView.clipsToBounds = true
        
        guard let viewModel = presentationModel.userViewModel else { return }
        authorImageView.kf.indicatorType = .activity
        authorImageView.kf.setImage(with: URL(string: viewModel.photoURL))
        
        authorLabel.font = UIFont.customFont(.robotoBoldFont(size: 16))
        authorLabel.text = viewModel.fullname
        authorLabel.textColor = PaletteColors.darkGray
    }
    
    private func configureFdTakeController() {
        fdTakeController.cancelText = Constants.cancel
        fdTakeController.takePhotoText = Constants.takePhoto
        fdTakeController.chooseFromLibraryText = Constants.chooseFromLibrary
        fdTakeController.allowsVideo = false
        fdTakeController.didGetPhoto = { [unowned self] (image, _) in
            self.imageToAttach = image
        }
    }
    
    @objc private func keyboardWillShow(_ notification: Notification) {
        if let keyboardFrame: NSValue = notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            let keyboardTopPoint = keyboardRectangle.minY
            heightTextView.constant = keyboardTopPoint - newsTextView.frame.minY
            heightImageView.constant = previewImageView.frame.maxY - newsTextView.frame.maxY
        }
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc private func editingChanged() {
        guard let text = newsTextView.text, text.count > 2
            else {
                postButtonItem.isEnabled = false
                return
        }
        postButtonItem.isEnabled = true
    }
    
    // MARK: - IBActions
    
    @IBAction private func cancelButtonItemTapped(_ sender: Any) {
        dismiss(animated: true)
        view.endEditing(true)
    }
    
    @IBAction func postButtonItemTapped(_ sender: Any) {
        view.endEditing(true)
        guard let title = titleTextField.text,
            let text = newsTextView.text else { return }
        if let image = self.imageToAttach {
            self.presentationModel.addNewsWithImage(title: title, text: text.addTags(), image: image) {
                self.titleTextField.text = ""
                self.newsTextView.text = ""
                self.imageToAttach = nil
                self.postButtonItem.isEnabled = false
            }
        } else {
            self.presentationModel.addNews(title: title, text: text) {
                self.titleTextField.text = ""
                self.newsTextView.text = ""
                self.imageToAttach = nil
                self.postButtonItem.isEnabled = false
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
        guard let text = textView.text, text.count > 7 else {
            postButtonItem.isEnabled = false
            return
        }
        postButtonItem.isEnabled = !text.removeBlankText().isEmpty
    }
}
