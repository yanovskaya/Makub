//
//  GamesAchievementsCell.swift
//  Makub
//
//  Created by Елена Яновская on 21.04.2018.
//  Copyright © 2018 Elena Yanovskaya. All rights reserved.
//

import UIKit

class GamesAchievementsCell: UICollectionViewCell {
    
    @IBOutlet var lineView: UIView!
    @IBOutlet var gamesStatisticsView: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        lineView.backgroundColor = UIColor.lightGray.withAlphaComponent(0.1)
    }
    
    func configureCellWidth(_ width: CGFloat) {
       widthAnchor.constraint(equalToConstant: width).isActive = true
    }
    
}
