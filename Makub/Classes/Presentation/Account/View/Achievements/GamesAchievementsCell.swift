//
//  GamesAchievementsCell.swift
//  Makub
//
//  Created by Елена Яновская on 21.04.2018.
//  Copyright © 2018 Elena Yanovskaya. All rights reserved.
//

import UIKit

final class GamesAchievementsCell: UICollectionViewCell, ViewModelConfigurable {
    
    @IBOutlet private var commonPositionLabel: UILabel!
    @IBOutlet private var classicPositionLabel: UILabel!
    @IBOutlet private var fastPositionLabel: UILabel!
    @IBOutlet private var veryFastPositionLabel: UILabel!
    
    @IBOutlet private var lineView: UIView!
    @IBOutlet private var gamesStatisticsView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        lineView.backgroundColor = UIColor.lightGray.withAlphaComponent(0.1)
    }
    
    func configure(for viewModel: UserViewModel) {
        commonPositionLabel.text = "#" + viewModel.commonPosition
        classicPositionLabel.text = "#" + viewModel.classicPosition
        fastPositionLabel.text = "#" + viewModel.fastPosition
        veryFastPositionLabel.text = "#" + viewModel.veryFastPosition
    }
    
    func configureCellWidth(_ width: CGFloat) {
       widthAnchor.constraint(equalToConstant: width).isActive = true
    }
    
}
