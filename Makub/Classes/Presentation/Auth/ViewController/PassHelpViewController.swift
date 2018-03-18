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
        static let backButton = "back_button"
        
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
        navigationItem.setHidesBackButton(true, animated: true)
        setBackButton()
        
        configureImage()
        configureTitleLabel()
        configureDescriptionLabel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        navigationItem.setHidesBackButton(true, animated: true)
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
//        let yourBackImage = UIImage(named: "back_button")
//        self.navigationController?.navigationBar.backIndicatorImage = yourBackImage
//        self.navigationController?.navigationBar.backIndicatorTransitionMaskImage = yourBackImage
//        self.navigationController?.navigationBar.backItem?.title = ""
//        var backButtonImage = UIImage(named: "back_button")
//        backButtonImage = backButtonImage?.stretchableImage(withLeftCapWidth: 0, topCapHeight: 0)
//        UIBarButtonItem.appearance().setBackButtonBackgroundImage(backButtonImage, for: .normal, barMetrics: .default)
//        UINavigationBar.appearance().shadowImage = UIImage()
//        UINavigationBar.appearance().setBackgroundImage(UIImage(), for: .default)
//        var backButtonImage = UIImage(named: Constants.backButton)
//        backButtonImage = backButtonImage?.stretchableImage(withLeftCapWidth: 28, topCapHeight: 22)
//        UIBarButtonItem.appearance().setBackButtonBackgroundImage(backButtonImage, for: .normal, barMetrics: .default)
//        
//        let backItem = UIBarButtonItem()
//        backItem.title = ""
//        navigationItem.backBarButtonItem = backItem
    }
    
}
