//
//  PassHelpViewController.swift
//  Makub
//
//  Created by Елена Яновская on 17.03.2018.
//  Copyright © 2018 Elena Yanovskaya. All rights reserved.
//

import UIKit

class PassHelpViewController: UIViewController {
    
    // MARK: - Constants
    
    private enum Constants {
        static let manImage = "sad_man"
        static let backButton = "arrow_left"
        
        static let titleLabel = "Не можете войти?"
        static let descriptionLabel = "Мы отправим тебе письмо на указанную почту с инструкциями для восстановленения доступа."
    }
    
    // MARK: - IBOutlets
    
    @IBOutlet var manImageView: UIImageView!
    
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var descriptionLabel: UILabel!
    
    // MARK: - ViewController lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.setNavigationBarHidden(false, animated: true)
        setBackButton()
        
        configureImage()
        configureTitleLabel()
        configureDescriptionLabel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        navigationItem.hidesBackButton = true
    }
    
    // MARK: - Private Methods
    
    private func configureImage() {
        manImageView.image = UIImage(named: Constants.manImage)
        manImageView.tintColor = PaleteColors.passHelp
    }
    
    private func configureTitleLabel() {
        titleLabel.textColor = PaleteColors.passHelp
        titleLabel.font = UIFont.customFont(.robotoBoldFont(size: 18))
        titleLabel.text = Constants.titleLabel
    }
    
    private func configureDescriptionLabel() {
        let text = Constants.descriptionLabel
        let attributedText = NSMutableAttributedString(string: text)
        let style = NSMutableParagraphStyle()
        style.minimumLineHeight = 20
        style.alignment = .center
        attributedText.addAttribute(.paragraphStyle, value: style, range: NSRange(location: 0, length: text.count))
        descriptionLabel.attributedText = attributedText
        descriptionLabel.textColor = PaleteColors.passHelp.withAlphaComponent(0.8)
        descriptionLabel.font = UIFont.customFont(.robotoRegularFont(size: 16))
        descriptionLabel.text = Constants.descriptionLabel
    }
    
    private func setBackButton() {
        let backButtonImage = UIImage(named: Constants.backButton)
        let leftBarButton = UIBarButtonItem(image: backButtonImage, style: .plain, target: self, action: #selector(backButtonPressed))
        self.navigationItem.leftBarButtonItem = leftBarButton
    }
    
    @objc private func backButtonPressed() {
        navigationController?.popViewController(animated: true)
    }

}
