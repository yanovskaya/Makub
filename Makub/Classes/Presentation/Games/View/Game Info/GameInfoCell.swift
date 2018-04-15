//
//  GameInfoCell.swift
//  Makub
//
//  Created by Елена Яновская on 15.04.2018.
//  Copyright © 2018 Elena Yanovskaya. All rights reserved.
//

import UIKit
import YouTubePlayer

final class GameInfoCell: UICollectionViewCell {
    
    // MARK: - IBOutlets
    
    @IBOutlet private var gameVideoPlayer: YouTubePlayerView!
    
    @IBOutlet private var dateLabel: UILabel!
    @IBOutlet private var clubLabel: UILabel!
    @IBOutlet private var photo1ImageView: UIImageView!
    @IBOutlet private var photo2ImageView: UIImageView!
    @IBOutlet private var score1Label: UILabel!
    @IBOutlet private var score2Label: UILabel!
    @IBOutlet private var colonLabel: UILabel!
    @IBOutlet private var player1Label: UILabel!
    @IBOutlet private var player2Label: UILabel!
    @IBOutlet private var tournamentLabel: UILabel!
    @IBOutlet private var descriptionLabel: UILabel!
    @IBOutlet private var commentsLabel: UILabel!
    
    
    @IBOutlet private var blueView: UIView!
    @IBOutlet private var lineView: UIView!
    
}
