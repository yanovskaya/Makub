//
//  RatingCell.swift
//  Makub
//
//  Created by Елена Яновская on 19.04.2018.
//  Copyright © 2018 Elena Yanovskaya. All rights reserved.
//

import Kingfisher
import UIKit

final class RatingCell: UICollectionViewCell {
    
    // MARK: - Constants
    
    private enum Constants {
        static let userImage = "photo_default"
    }
    
    private enum SizeConstants {
        static let userWidth: CGFloat = 135
        static let userHeight: CGFloat = 135
    }
    
    // MARK: - IBOutlets
    
    @IBOutlet private var borderView: UIView!
    @IBOutlet private var playerImageView: UIImageView!
    @IBOutlet private var ratingPositionLabel: UILabel!
    @IBOutlet private var playerLabel: UILabel!
    @IBOutlet private var clubLabel: UILabel!
    @IBOutlet private var scoreLabel: UILabel!
    
    // MARK: - Private Properties
    
    private let indicator = UserIndicator()
    private var type: RatingType!
    private var position: Int!
    
    // MARK: - View lifecycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        playerImageView.clipsToBounds = true
        playerImageView.layer.cornerRadius = playerImageView.frame.width / 2
    }
    
    // MARK: - Prepare for Reuse
    
    override func prepareForReuse() {
        super.prepareForReuse()
        playerImageView.image = nil
        ratingPositionLabel.text = nil
        playerLabel.text = nil
        clubLabel.text = nil
        scoreLabel.text = nil
    }
    
    // MARK: - Public Methods
    
    func configure(for viewModel: RatingViewModel) {
        ratingPositionLabel.text = String(position)
        playerLabel.text = viewModel.fullname
        clubLabel.text = viewModel.club
        
        switch type {
        case .common:
            scoreLabel.text = String(viewModel.commonRating)
        case .classic:
            scoreLabel.text = String(viewModel.classicRating)
        case .fast:
            scoreLabel.text = String(viewModel.fastRating)
        case .veryFast:
            scoreLabel.text = String(viewModel.veryFastRating)
        default:
            break
        }
        if let photoURL = viewModel.photoURL {
            let sizeProcessor = ResizingImageProcessor(referenceSize: CGSize(width: SizeConstants.userWidth, height: SizeConstants.userHeight), mode: .aspectFill)
            playerImageView.kf.indicatorType = .custom(indicator: indicator)
            playerImageView.kf.setImage(with: URL(string: photoURL), placeholder: nil, options: [.processor(sizeProcessor)], completionHandler: { (image, _, _, _) in
                if image == nil {
                    self.playerImageView.image = UIImage(named: Constants.userImage)
                }
            })
        } else {
            self.playerImageView.image = UIImage(named: Constants.userImage)
        }
    }
    
    // MARK: - Private Methods
    
    private func configureLayout() {
        self.contentView.translatesAutoresizingMaskIntoConstraints = false
        let screenWidth = UIScreen.main.bounds.size.width
        widthAnchor.constraint(equalToConstant: screenWidth).isActive = true
    }
}
