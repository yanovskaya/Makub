//
//  SettingCell.swift
//  Makub
//
//  Created by Елена Яновская on 21.04.2018.
//  Copyright © 2018 Elena Yanovskaya. All rights reserved.
//

import UIKit

class SettingCell: UICollectionViewCell, ViewModelConfigurable {
    
    // MARK: - Constants
    
    private enum Constants {
        static let settingImage = "newspaper"
    }
    
    // MARK: - IBOutlets
    
    @IBOutlet private var settingLabel: UILabel!
    @IBOutlet private var settingImageView: UIImageView!
    @IBOutlet private var lineView: UIView!
    @IBOutlet private var lineViewHeight: NSLayoutConstraint!
    
    // MARK: - View lifecycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        configureColor()
        configureFont()
        configureImageView()
    }
    
    // MARK: - Public Methods
    
    func configure(for viewModel: String) {
        settingLabel.text = viewModel
    }
    
    func configureSeperator(isHidden: Bool = false) {
        if isHidden {
            lineViewHeight.constant = 0
        } else {
            lineViewHeight.constant = 1
        }
    }
    
    // MARK: - Private Methods
    
    private func configureColor() {
        lineView.backgroundColor = UIColor.lightGray.withAlphaComponent(0.1)
        settingLabel.textColor = PaletteColors.darkGray
    }
    
    private func configureFont() {
        settingLabel.font = UIFont.customFont(.robotoRegularFont(size: 16))
    }
    
    private func configureImageView() {
        settingImageView.image = UIImage(named: Constants.settingImage)
    }
}
