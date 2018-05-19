//
//  CupsAchievementsCell.swift
//  Makub
//
//  Created by Елена Яновская on 21.04.2018.
//  Copyright © 2018 Elena Yanovskaya. All rights reserved.
//

import UIKit

final class CupsAchievementsCell: UICollectionViewCell {
    
    // MARK: - Constants

    private enum Constants {
        static let cupImage = "trophy"
    }
    
    // MARK: - IBOutlets
    
    @IBOutlet private var achievementLabel: UILabel!
    @IBOutlet private var cupImageView: UIImageView!
    
    // MARK: - View lifecycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        configureImageView()
        configureLabel()
    }
    
    // MARK: - Public Methods
    
    func configure(for achievement: String) {
        achievementLabel.text = achievement
    }
    
    // MARK: - Private Methods
    
    private func configureImageView() {
        cupImageView.image = UIImage(named: Constants.cupImage)?.withRenderingMode(.alwaysTemplate)
        cupImageView.tintColor = PaletteColors.darkGray
    }
    
    private func configureLabel() {
        achievementLabel.textColor = PaletteColors.textGray
        achievementLabel.font = UIFont.customFont(.robotoRegularFont(size: 15))
        achievementLabel.setLineSpacing(lineSpacing: 5)
    }
}
