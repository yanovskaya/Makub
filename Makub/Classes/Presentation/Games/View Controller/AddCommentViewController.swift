//
//  AddCommentViewController.swift
//  Makub
//
//  Created by Елена Яновская on 16.04.2018.
//  Copyright © 2018 Elena Yanovskaya. All rights reserved.
//

import PKHUD
import UIKit

final class AddCommentViewController: UIViewController {
    
    // MARK: - Constants
    
    private enum Constants {
        static let title = "Комментарий"
        static let cancelButtonItem = "Отмена"
        static let doneButtonItem = "Готово"
        static let pkhudTitle = "Подождите"
        static let pkhudSubtitle = "Публикуем новость"
        
        static let userImage = "photo_default"
    }
    
    // MARK: - IBOutlets
    
    @IBOutlet private var navigationBar: UINavigationBar!
    @IBOutlet private var authorImageView: UIImageView!
    @IBOutlet private var authorLabel: UILabel!
    @IBOutlet private var commentTextView: UITextView!
    
    @IBOutlet private var cancelButtonItem: UIBarButtonItem!
    @IBOutlet private var doneButtonItem: UIBarButtonItem!
    
    @IBOutlet private var heightTextView: NSLayoutConstraint!
    
    // MARK: - Public Properties
    
    var presentationModel = AddCommentPresentationModel()
    
    weak var delegate: AddCommentViewControllerDelegate?
    
    // MARK: - Private Properties
    
    private let indicator = UserIndicator()
    
    // MARK: - ViewController lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        configureNavigationItems()
        configureTextView()
        configureAuthorView()
        
        bindEvents()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        HUD.hide()
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
                self.delegate?.addCommentToCollectionView()
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
                    self.commentTextView.becomeFirstResponder()
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
        commentTextView.textContainerInset = UIEdgeInsets(top: 5, left: 20, bottom: 10, right: 20)
        commentTextView.font = UIFont.customFont(.robotoRegularFont(size: 17))
        commentTextView.textColor = PaletteColors.darkGray
        commentTextView.becomeFirstResponder()
        commentTextView.delegate = self
        commentTextView.target(forAction: #selector(editingChanged), withSender: self)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: .UIKeyboardWillShow, object: nil)
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
    
    @objc private func keyboardWillShow(_ notification: Notification) {
        if let keyboardFrame: NSValue = notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            let keyboardTopPoint = keyboardRectangle.minY
            heightTextView.constant = keyboardTopPoint - commentTextView.frame.minY
        }
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc private func editingChanged() {
        guard let text = commentTextView.text, text.count > 2
            else {
                doneButtonItem.isEnabled = false
                return
        }
        doneButtonItem.isEnabled = true
    }
    
    // MARK: - IBActions
    
    @IBAction private func cancelButtonItemTapped(_ sender: Any) {
        dismiss(animated: true)
        view.endEditing(true)
    }
    
    @IBAction func postButtonItemTapped(_ sender: Any) {
        view.endEditing(true)
        guard let comment = commentTextView.text else { return }
        self.presentationModel.addComment(comment: comment.addTags())
    }
    
}

// MARK: - UITextViewDelegate

extension AddCommentViewController: UITextViewDelegate {
    
    func textViewDidChange(_ textView: UITextView) {
        guard let text = textView.text, text.removeWhitespaces().count > 0 else {
            doneButtonItem.isEnabled = false
            return
        }
        doneButtonItem.isEnabled = !text.removeBlankText().isEmpty
    }
}
