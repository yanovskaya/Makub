//
//  RatingCell.swift
//  Makub
//
//  Created by Елена Яновская on 19.04.2018.
//  Copyright © 2018 Elena Yanovskaya. All rights reserved.
//

import UIKit

final class RatingCell: UICollectionViewCell {
    
    // MARK: - IBOutlets
    
    @IBOutlet private var borderView: UIView!
    @IBOutlet private var playerImageView: UIImageView!
    @IBOutlet private var ratingPositionLabel: UILabel!
    @IBOutlet private var playerLabel: UILabel!
    @IBOutlet private var clubLabel: UILabel!
    @IBOutlet private var scoreLabel: UILabel!
}
