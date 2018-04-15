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

final class GameInfoCell: UICollectionViewCell, ViewModelConfigurable, YouTubePlayerDelegate {
    
    // MARK: - Constants
    
    private enum Constants {
        static let userImage = "photo_default"
    }
    
    private enum SizeConstants {
        static let photoWidth: CGFloat = 200
        static let photoHeight: CGFloat = 200
    }
    
    // MARK: - Private Property
    
    private let indicator = UserIndicator()
    
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
    @IBOutlet var tournamentLabel: UILabel!
    @IBOutlet private var descriptionLabel: UILabel!
    
    let spinner = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
    
    @IBOutlet var videoContainerView: UIView!
    @IBOutlet var blueView: UIView!
    @IBOutlet private var lineView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        gameVideoPlayer.isHidden = true
        colonLabel.text = ":"
        blueView.backgroundColor = PaletteColors.blueTint.withAlphaComponent(0.1)
        gameVideoPlayer.delegate = self
        videoContainerView.backgroundColor = PaletteColors.darkGray
        spinner.startAnimating()
        videoContainerView.addSubview(spinner)
  
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        photo1ImageView.clipsToBounds = true
        photo1ImageView.layer.cornerRadius = photo1ImageView.frame.width / 2
        
        photo2ImageView.clipsToBounds = true
        photo2ImageView.layer.cornerRadius = photo2ImageView.frame.width / 2
        spinner.center = videoContainerView.center
    }
    
    func configure(for viewModel: GameViewModel) {
        if let video = viewModel.video {
            gameVideoPlayer.loadVideoID(video)
        } else {
            videoContainerView.heightAnchor.constraint(equalToConstant: 0).isActive = true
        }
        dateLabel.text = viewModel.playerTime
        clubLabel.text = viewModel.club
        score1Label.text = viewModel.score1
        score2Label.text = viewModel.score2
        player1Label.text = viewModel.player1
        player2Label.text = viewModel.player2
        
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
    }
    
    func playerReady(_ videoPlayer: YouTubePlayerView) {
        spinner.stopAnimating()
        videoPlayer.isHidden = false
    }
    
    func configureTournament(for viewModel: TournamentViewModel) {
        tournamentLabel.text = viewModel.tournament
        if let description = viewModel.description {
            descriptionLabel.text = description
        }
    }
}
