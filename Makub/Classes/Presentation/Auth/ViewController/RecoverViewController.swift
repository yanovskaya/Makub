//
//  RecoverViewController.swift
//  Makub
//
//  Created by Елена Яновская on 17.03.2018.
//  Copyright © 2018 Elena Yanovskaya. All rights reserved.
//

import UIKit

class RecoverViewController: UIViewController {
    
    // MARK: - Constants
    
    private enum Constants {
        static let manImage = "sad_man"
        static let backButton = "arrow_left"
        
        static let helpTitleLabel = "Не можете войти?"
        static let helpDescriptionLabel = "Мы отправим тебе письмо на указанную почту с инструкциями для восстановленения доступа."
    }
    
    private enum LayoutConstants {
        static let minimumLineHeight: CGFloat = 20
    }
    
    // MARK: - IBOutlets
    
    @IBOutlet var manImageView: UIImageView!
    
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var descriptionLabel: UILabel!
    
    // MARK: - ViewController lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.setNavigationBarHidden(false, animated: true)
        navigationController?.navigationBar.topItem?.title = " "
        
        configureImage()
        configureTitleLabel()
        configureDescriptionLabel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
    }
    
    // MARK: - Private Methods
    
    private func configureImage() {
        manImageView.image = UIImage(named: Constants.manImage)
        manImageView.tintColor = PaletteColors.passHelp
    }
    
    private func configureTitleLabel() {
        titleLabel.textColor = PaletteColors.passHelp
        titleLabel.font = UIFont.customFont(.robotoBoldFont(size: 18))
        titleLabel.text = Constants.helpTitleLabel
    }
    
    private func configureDescriptionLabel() {
        let text = Constants.helpDescriptionLabel
        let attributedText = NSMutableAttributedString(string: text)
        let style = NSMutableParagraphStyle()
        style.minimumLineHeight = LayoutConstants.minimumLineHeight
        style.alignment = .center
        attributedText.addAttribute(.paragraphStyle, value: style, range: NSRange(location: 0, length: text.count))
        descriptionLabel.attributedText = attributedText
        descriptionLabel.textColor = PaletteColors.passHelp.withAlphaComponent(0.8)
        descriptionLabel.font = UIFont.customFont(.robotoRegularFont(size: 16))
        descriptionLabel.text = Constants.helpDescriptionLabel
    }
    
    @IBAction func recoverButtonTapped(_ sender: Any) {
        titleLabel.text = "fdddfg"
        manImageView.image = UIImage(named: Constants.backButton)
    }
    

}
