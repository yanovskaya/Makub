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
        static let title = "Новость"
        static let cancelButtonItem = "Отмена"
        static let doneButtonItem = "Готово"
        static let titleTextField = "Название..."
        static let pkhudTitle = "Подождите"
        static let pkhudSubtitle = "Публикуем новость"
        
        static let cancel = "Отмена"
        static let noSources = "Нет доступных источников для выбора фото"
        static let chooseFromLibrary = "Выбрать из библиотеки"
        static let takePhoto = "Сфотографировать"
        
        static let attachButton = "paperclip"
        static let removeButton = "close"
        static let userImage = "photo_default"
    }
    
    // MARK: - IBOutlets
    
    @IBOutlet private var navigationBar: UINavigationBar!
    @IBOutlet private var cancelButtonItem: UIBarButtonItem!
    @IBOutlet private var doneButtonItem: UIBarButtonItem!
    
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
    
    var presentationModel = AddNewsPresentationModel()
    
    weak var delegate: AddNewsViewControllerDelegate?
    
    // MARK: - Private Properties
    
    private var fdTakeController = FDTakeController()
    
    private let indicator = UserIndicator()
    
    private var imageToAttach: UIImage? {
        didSet {
            if imageToAttach != nil {
                attachButton.tintColor = PaletteColors.blueTint
                heightRemoveButton.isActive = false
                removeButton.setImage(UIImage(named: Constants.removeButton), for: .normal)
                previewImageView.image = imageToAttach
            } else {
                attachButton.tintColor = PaletteColors.darkGray
                removeButton.setImage(nil, for: .normal)
                heightRemoveButton.isActive = true
                previewImageView.image = nil
                newsTextView.becomeFirstResponder()
            }
        }
    }
    
    // MARK: - ViewController lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        configureNavigationItems()
        configureFdTakeController()
        configureRemoveButton()
        configureAttachButton()
        configureTextView()
        configureTextField()
        configureAuthorView()
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
                HUD.hide()
                self.delegate?.addNewsToCollectionView()
                self.dismiss(animated: true)
            case .error (let code):
                switch code {
                case -1009, -1001:
                    HUD.show(.labeledError(title: ErrorDescription.title.rawValue, subtitle: ErrorDescription.network.rawValue))
                default:
                    HUD.show(.labeledError(title: ErrorDescription.title.rawValue, subtitle: ErrorDescription.server.rawValue))
                }
                HUD.hide(afterDelay: 1.0)
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                    self.newsTextView.becomeFirstResponder()
                }
            }
        }
    }
    
    private func configureNavigationItems() {
        navigationBar.topItem?.title = Constants.title
        cancelButtonItem.title = Constants.cancelButtonItem
        doneButtonItem.title = Constants.doneButtonItem
        
        let titleTextAttributes: [NSAttributedStringKey: Any] = [NSAttributedStringKey.foregroundColor: PaletteColors.darkGray,
                                   NSAttributedStringKey.font: UIFont.customFont(.robotoMediumFont(size: 17))]
        
        let cancelButtonAttributes = [NSAttributedStringKey.foregroundColor: PaletteColors.blueTint,
                                                                      NSAttributedStringKey.font: UIFont.customFont(.robotoRegularFont(size: 17))]
        let doneButtonAttributes = [NSAttributedStringKey.foregroundColor: PaletteColors.blueTint,
                                     NSAttributedStringKey.font: UIFont.customFont(.robotoBoldFont(size: 17))]
        navigationBar.titleTextAttributes = titleTextAttributes
        cancelButtonItem.setTitleTextAttributes(cancelButtonAttributes, for: .normal)
        cancelButtonItem.setTitleTextAttributes(cancelButtonAttributes, for: .selected)
        
        doneButtonItem.setTitleTextAttributes(doneButtonAttributes, for: .normal)
        doneButtonItem.setTitleTextAttributes(doneButtonAttributes, for: .selected)
        
        doneButtonItem.setTitleTextAttributes([NSAttributedStringKey.font: UIFont.customFont(.robotoBoldFont(size: 17))], for: .disabled)
        
        doneButtonItem.isEnabled = false
    }
    
    private func configureTextView() {
        newsTextView.textContainerInset = UIEdgeInsets(top: 5, left: 20, bottom: 10, right: 20)
        newsTextView.font = UIFont.customFont(.robotoRegularFont(size: 17))
        newsTextView.textColor = PaletteColors.darkGray
        newsTextView.becomeFirstResponder()
        newsTextView.delegate = self
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
        authorImageView.kf.indicatorType = .custom(indicator: indicator)
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
    
    // MARK: - IBActions
    
    @IBAction private func cancelButtonItemTapped(_ sender: Any) {
        dismiss(animated: true)
        view.endEditing(true)
    }
    
    @IBAction func postButtonItemTapped(_ sender: Any) {
        view.endEditing(true)
        bindEvents()
        guard let title = titleTextField.text,
            let text = newsTextView.text else { return }
        if let image = self.imageToAttach {
            self.presentationModel.addNewsWithImage(title: title, text: text.addTags(), image: image)
        } else {
            self.presentationModel.addNews(title: title, text: text.addTags())
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
        guard let text = textView.text, text.removeWhitespaces().count > 0 else {
            doneButtonItem.isEnabled = false
            return
        }
        doneButtonItem.isEnabled = !text.removeBlankText().isEmpty
    }
}
