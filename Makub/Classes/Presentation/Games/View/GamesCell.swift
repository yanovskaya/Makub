//
//  GamesCell.swift
//  Makub
//
//  Created by Елена Яновская on 02.04.2018.
//  Copyright © 2018 Elena Yanovskaya. All rights reserved.
//

import Kingfisher
import UIKit

final class GamesCell: UITableViewCell, ViewModelConfigurable {
    
    // MARK: - Constants
    
    private enum Constants {
        static let userImage = "user"
    }

    // MARK: - IBOutlets
    
    @IBOutlet private var stageLabel: UILabel!
    @IBOutlet private var typeLabel: UILabel!
    
    @IBOutlet private var photo1ImageView: UIImageView!
    @IBOutlet private var photo2ImageView: UIImageView!
    @IBOutlet private var player1Label: UILabel!
    @IBOutlet private var player2Label: UILabel!
    @IBOutlet private var score1Label: UILabel!
    @IBOutlet private var score2Label: UILabel!
    
    // MARK: - Private Property
    
    private var firstPlayerWon: Bool! {
        didSet {
            configureScoreColor()
        }
    }
    
    // MARK: - View lifecycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        configureFont()
        configureColor()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        photo1ImageView.clipsToBounds = true
        photo1ImageView.layer.cornerRadius = photo1ImageView.frame.width / 2
        
        photo2ImageView.clipsToBounds = true
        photo2ImageView.layer.cornerRadius = photo2ImageView.frame.width / 2
    }
    
    private enum SizeConstants {
        static let photoWidth: CGFloat = 90
        static let photoHeight: CGFloat = 90
    }
    
    // MARK: - Prepare for Reuse
    
    override func prepareForReuse() {
        super.prepareForReuse()
        stageLabel.text = nil
        typeLabel.text = nil
        player1Label.text = nil
        player2Label.text = nil
        score1Label.text = nil
        score2Label.text = nil
        photo1ImageView.image = nil
        photo2ImageView.image = nil
    }
    
    // MARK: - Public Methods
    
    func configure(for viewModel: GamesViewModel) {
        firstPlayerWon = viewModel.score1 > viewModel.score2
        typeLabel.text = viewModel.type
        score1Label.text = viewModel.score1
        score2Label.text = viewModel.score2
        player1Label.text = viewModel.player1
        player2Label.text = viewModel.player2
        
        let sizeProcessor = ResizingImageProcessor(referenceSize: CGSize(width: SizeConstants.photoWidth, height: SizeConstants.photoHeight), mode: .aspectFill)
        
        if let photo1URL = viewModel.photo1URL {
            photo1ImageView.kf.indicatorType = .activity
            photo1ImageView.kf.setImage(with: URL(string: photo1URL), placeholder: nil, options: [.processor(sizeProcessor)], completionHandler: { (image, _, _, _) in
                if image == nil {
                    self.photo1ImageView.image = UIImage(named: Constants.userImage)
                }
            })
        } else {
            photo1ImageView.image = UIImage(named: Constants.userImage)
        }
        if let photo2URL = viewModel.photo2URL {
            photo2ImageView.kf.indicatorType = .activity
            photo2ImageView.kf.setImage(with: URL(string: photo2URL), placeholder: nil, options: [.processor(sizeProcessor)], completionHandler: { (image, _, _, _) in
                if image == nil {
                    self.photo2ImageView.image = UIImage(named: Constants.userImage)
                }
            })
        } else {
            photo2ImageView.image = UIImage(named: Constants.userImage)
        }
    }
    
    // MARK: - Private Methods
    
    private func configureFont() {
        player1Label.font = UIFont.customFont(.robotoRegularFont(size: 16))
        player2Label.font = UIFont.customFont(.robotoRegularFont(size: 16))
        typeLabel.font = UIFont.customFont(.robotoRegularFont(size: 12))
        score1Label.font = UIFont.customFont(.robotoMediumFont(size: 23))
        score2Label.font = UIFont.customFont(.robotoMediumFont(size: 23))
        stageLabel.font = UIFont.customFont(.robotoRegularFont(size: 12))
    }
    
    private func configureColor() {
        player1Label.textColor = PaletteColors.darkGray
        player2Label.textColor = PaletteColors.darkGray
        typeLabel.textColor = PaletteColors.textGray
        stageLabel.textColor = PaletteColors.darkGray
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
