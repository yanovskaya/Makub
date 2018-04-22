//
//  GameInfoCell.swift
//  Makub
//
//  Created by Елена Яновская on 15.04.2018.
//  Copyright © 2018 Elena Yanovskaya. All rights reserved.
//

import Kingfisher
import UIKit
import YouTubePlayer

final class GameInfoCell: UICollectionViewCell, ViewModelConfigurable {
    
    // MARK: - Constants
    
    private enum Constants {
        static let userImage = "photo_default"
    }
    
    private enum LayoutConstants {
        static let bottomTournamentLabel: CGFloat = -16
    }
    
    private enum SizeConstants {
        static let photoWidth: CGFloat = 200
        static let photoHeight: CGFloat = 200
        static let videoAspectRatio: CGFloat = 9 / 16
    }
    
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
    
    @IBOutlet private var videoContainerView: UIView!
    @IBOutlet private var blueView: UIView!
    @IBOutlet private var lineView: UIView!
    
    @IBOutlet private var gameVideoPlayerHeight: NSLayoutConstraint!
    
    
    // MARK: - Private Property
    
    private let indicator = UserIndicator()
    private var spinner: UIActivityIndicatorView!
    
    private var firstPlayerWon: Bool! {
        didSet {
            configureScoreColor()
        }
    }
    
    // MARK: - View lifecycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        configureViews()
        configureSpinner()
        
        configureFont()
        configureColor()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        photo1ImageView.clipsToBounds = true
        photo1ImageView.layer.cornerRadius = photo1ImageView.frame.width / 2
        
        photo2ImageView.clipsToBounds = true
        photo2ImageView.layer.cornerRadius = photo2ImageView.frame.width / 2
        
        spinner.center = videoContainerView.center
    }
    
    // MARK: - Public Methods
    
    func configure(for viewModel: GameViewModel) {
        dateLabel.text = viewModel.playerTime
        clubLabel.text = viewModel.club
        firstPlayerWon = viewModel.score1 > viewModel.score2
        score1Label.text = viewModel.score1
        score2Label.text = viewModel.score2
        
        player1Label.text = viewModel.player1
        player2Label.text = viewModel.player2
        
        let player1Count = viewModel.player1.count
        let player2Count = viewModel.player2.count
        configureSizeLabel(sum: player1Count + player2Count,
                           characters: max(player1Count, player2Count))
        
        let sizeProcessor = ResizingImageProcessor(referenceSize: CGSize(width: SizeConstants.photoWidth, height: SizeConstants.photoHeight), mode: .aspectFill)
        
        if let photo1URL = viewModel.photo1URL {
            photo1ImageView.kf.indicatorType = .custom(indicator: indicator)
            photo1ImageView.kf.setImage(with: URL(string: photo1URL), placeholder: nil, options: [.processor(sizeProcessor)], completionHandler: { (image, _, _, _) in
                if image == nil {
                    self.photo1ImageView.image = UIImage(named: Constants.userImage)
                }
            })
        } else {
            photo1ImageView.image = UIImage(named: Constants.userImage)
        }
        
        if let photo2URL = viewModel.photo2URL {
            photo2ImageView.kf.indicatorType = .custom(indicator: indicator)
            photo2ImageView.kf.setImage(with: URL(string: photo2URL), placeholder: nil, options: [.processor(sizeProcessor)], completionHandler: { (image, _, _, _) in
                if image == nil {
                    self.photo2ImageView.image = UIImage(named: Constants.userImage)
                }
            })
        } else {
            photo2ImageView.image = UIImage(named: Constants.userImage)
        }
        
        if let video = viewModel.video {
            spinner.startAnimating()
            gameVideoPlayer.loadVideoID(video)
            let height = frame.width * SizeConstants.videoAspectRatio
            gameVideoPlayerHeight.constant = height
        } else {
            gameVideoPlayerHeight.constant = 0
        }
    }
    
    func configureTournament(for viewModel: TournamentForGameViewModel) {
        tournamentLabel.text = viewModel.tournament
        if let description = viewModel.description {
            descriptionLabel.text = description
        } else {
            descriptionLabel.removeFromSuperview()
            tournamentLabel.bottomAnchor.constraint(equalTo: blueView.bottomAnchor, constant: LayoutConstants.bottomTournamentLabel).isActive = true
        }
    }
    
    func configureCellWidth(_ width: CGFloat) {
        widthAnchor.constraint(equalToConstant: width).isActive = true
    }
    
    // MARK: - Private Methods
    
    private func configureSpinner() {
        gameVideoPlayer.isHidden = true
        spinner = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
        videoContainerView.addSubview(spinner)
    }
    
    private func configureViews() {
        gameVideoPlayer.delegate = self
        colonLabel.text = ":"
        videoContainerView.backgroundColor = PaletteColors.darkGray
        blueView.backgroundColor = PaletteColors.blueTint.withAlphaComponent(0.1)
    }
    
    private func configureFont() {
        dateLabel.font = UIFont.customFont(.robotoRegularFont(size: 12))
        clubLabel.font = UIFont.customFont(.robotoRegularFont(size: 13))
        tournamentLabel.font = UIFont.customFont(.robotoRegularFont(size: 16))
        descriptionLabel.font = UIFont.customFont(.robotoRegularFont(size: 15))
        score1Label.font = UIFont.customFont(.robotoRegularFont(size: 25))
        score2Label.font = UIFont.customFont(.robotoRegularFont(size: 25))
        colonLabel.font = UIFont.customFont(.robotoRegularFont(size: 25))
        
        clubLabel.setLineSpacing(lineSpacing: 3)
        tournamentLabel.setLineSpacing(lineSpacing: 3)
        descriptionLabel.setLineSpacing(lineSpacing: 4)
    }
    
    private func configureColor() {
        player1Label.textColor = PaletteColors.darkGray
        player2Label.textColor = PaletteColors.darkGray
        tournamentLabel.textColor = PaletteColors.darkGray
        dateLabel.textColor = PaletteColors.textGray
        clubLabel.textColor = PaletteColors.textGray
        descriptionLabel.textColor = PaletteColors.textGray
        colonLabel.textColor = PaletteColors.textGray
        lineView.backgroundColor = UIColor.lightGray.withAlphaComponent(0.2)
    }
    
    private func configureSizeLabel(sum: Int, characters: Int) {
        let size: CGFloat
        if characters < 15 {
            size = 16
        } else if characters < 18 {
            size = 15
        } else if characters < 22, sum < 34 {
            size = 14
        } else {
            size = 13
        }
        player1Label.font = UIFont.customFont(.robotoMediumFont(size: size))
        player2Label.font = UIFont.customFont(.robotoMediumFont(size: size))
    }
    
    private func configureScoreColor() {
        if firstPlayerWon {
            score1Label.textColor = PaletteColors.winColor
            score2Label.textColor = PaletteColors.loseColor
        } else {
            score1Label.textColor = PaletteColors.loseColor
            score2Label.textColor = PaletteColors.winColor
        }
    }
}

// MARK: - YouTubePlayerDelegate

extension GameInfoCell: YouTubePlayerDelegate {
    
    func playerReady(_ videoPlayer: YouTubePlayerView) {
        spinner.stopAnimating()
        videoPlayer.isHidden = false
    }
}
