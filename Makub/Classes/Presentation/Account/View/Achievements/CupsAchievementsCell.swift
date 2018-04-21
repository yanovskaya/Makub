//
//  CupsAchievementsCell.swift
//  Makub
//
//  Created by Елена Яновская on 21.04.2018.
//  Copyright © 2018 Elena Yanovskaya. All rights reserved.
//

import UIKit

final class CupsAchievementsCell: UICollectionViewCell {

    private enum Constants {
        static let cupImage = "trophy"
    }
    
    @IBOutlet private var achievementLabel: UILabel!
    @IBOutlet private var cupImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        configureImageView()
        configureLabel()
    }
    
    func configure(for achievement: String) {
        achievementLabel.text = achievement
    }
    
    private func configureImageView() {
        cupImageView.image = UIImage(named: Constants.cupImage)?.withRenderingMode(.alwaysTemplate)
        cupImageView.tintColor = PaletteColors.textGray
    }
    
    private func configureLabel() {
        achievementLabel.textColor = PaletteColors.darkGray
        achievementLabel.font = UIFont.customFont(.robotoRegularFont(size: 16))
    }
}
