//
//  NewsCell.swift
//  Makub
//
//  Created by Елена Яновская on 25.03.2018.
//  Copyright © 2018 Elena Yanovskaya. All rights reserved.
//

import Kingfisher
import UIKit

final class NewsCell: UICollectionViewCell, ViewModelConfigurable {
    
    // MARK: - Constants
    
    private enum Constants {
        static let userImage = "photo_default"
    }
    
    private enum LayoutConstants {
        static let imageHeight: CGFloat = 167
        static let bottomImageDistance: CGFloat = 198
        static let bottomDistance: CGFloat = 20
        
    }
    
    private enum SizeConstants {
        static let photoWidth: CGFloat = 120
        static let photoHeight: CGFloat = 120
        
        static let imageWidth: CGFloat = 501
        static let imageHeight: CGFloat = 1077
    }
    
    // MARK: - IBOutlets
    
    @IBOutlet private var authorLabel: UILabel!
    @IBOutlet private var authorImageView: UIImageView!
    @IBOutlet private var dateLabel: UILabel!
    @IBOutlet private var illustrationImageView: UIImageView!
    @IBOutlet private var titleLabel: UILabel!
    @IBOutlet private var descriptionLabel: UILabel!
    
    @IBOutlet private var lineView: UIView!
    
    @IBOutlet private var imageHeight: NSLayoutConstraint!
    @IBOutlet private var bottomDistance: NSLayoutConstraint!
    
    
    // MARK: - View lifecycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        configureLayout()
        configureFont()
        configureColor()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        authorImageView.clipsToBounds = true
        authorImageView.layer.cornerRadius = authorImageView.frame.width / 2
    }
    
    // MARK: - Prepare for Reuse
    
    override func prepareForReuse() {
        super.prepareForReuse()
        authorLabel.text = nil
        authorImageView.image = nil
        dateLabel.text = nil
        illustrationImageView.image = nil
    }
    
    // MARK: - Public Methods
    
    func configure(for viewModel: NewsViewModel) {
        dateLabel.text = viewModel.date
        titleLabel.text = viewModel.title
        descriptionLabel.text = viewModel.text
        authorLabel.text = viewModel.fullName
        
        if let imageURL = viewModel.imageURL {
            imageHeight.constant = LayoutConstants.imageHeight
            bottomDistance.constant = LayoutConstants.bottomImageDistance
            let sizeProcessor = ResizingImageProcessor(referenceSize: CGSize(width: SizeConstants.imageWidth, height: SizeConstants.imageHeight), mode: .aspectFill)
            illustrationImageView.kf.indicatorType = .activity
            illustrationImageView.kf.setImage(with: URL(string: imageURL), placeholder: nil, options: [.processor(sizeProcessor)], completionHandler: { (image, _, _, _) in
                if image == nil {
                    self.bottomDistance.constant = LayoutConstants.bottomDistance
                    self.imageHeight.constant = 0
                }
            })
        } else {
            bottomDistance.constant = LayoutConstants.bottomDistance
            imageHeight.constant = 0
        }
        if let photoURL = viewModel.photoURL {
            let sizeProcessor = ResizingImageProcessor(referenceSize: CGSize(width: SizeConstants.photoWidth, height: SizeConstants.photoHeight), mode: .aspectFill)
            authorImageView.kf.indicatorType = .activity
            authorImageView.kf.setImage(with: URL(string: photoURL), placeholder: nil, options: [.processor(sizeProcessor)], completionHandler: { (image, _, _, _) in
                if image == nil {
                    self.authorImageView.image = UIImage(named: Constants.userImage)
                }
            })
        } else {
            authorImageView.image = UIImage(named: Constants.userImage)
        }
    }
    
    // MARK: - Private Methods
    
    private func configureLayout() {
        self.contentView.translatesAutoresizingMaskIntoConstraints = false
        let screenWidth = UIScreen.main.bounds.size.width
        widthAnchor.constraint(equalToConstant: screenWidth).isActive = true
    }
    
    private func configureFont() {
        authorLabel.font = UIFont.customFont(.robotoMediumFont(size: 14))
        dateLabel.font = UIFont.customFont(.robotoRegularFont(size: 12))
        titleLabel.font = UIFont.customFont(.robotoBoldFont(size: 16))
        descriptionLabel.font = UIFont.customFont(.robotoRegularFont(size: 14))
    }
    
    private func configureColor() {
        authorLabel.textColor = PaletteColors.darkGray
        dateLabel.textColor = PaletteColors.textGray
        titleLabel.textColor = PaletteColors.darkGray
        descriptionLabel.textColor = PaletteColors.textGray
        lineView.backgroundColor = UIColor.lightGray.withAlphaComponent(0.2)
    }
}
