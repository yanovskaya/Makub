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
        static let userImage = "user"
    }
    
    // MARK: - IBOutlets
    
    @IBOutlet private var authorLabel: UILabel!
    @IBOutlet private var authorImageView: UIImageView!
    @IBOutlet private var dateLabel: UILabel!
    @IBOutlet private var illustrationImageView: UIImageView!
    @IBOutlet private var titleLabel: UILabel!
    @IBOutlet private var descriptionLabel: UILabel!
    
    @IBOutlet private var lineView: UIView!
    
    // MARK: - View lifecycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        configureLayout()
        configureFont()
        configureColor()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        authorImageView.layer.cornerRadius = authorImageView.frame.width / 2
        authorImageView.clipsToBounds = true
    }
    
    // MARK: - Public Methods
    
    func configure(for viewModel: NewsViewModel) {
        dateLabel.text = viewModel.date
        titleLabel.text = viewModel.title
        descriptionLabel.text = viewModel.text
        
        if let fullname = viewModel.fullName {
            authorLabel.text = fullname
        } else {
            authorLabel.removeFromSuperview()
        }
        if let imageURL = viewModel.imageURL {
            illustrationImageView.kf.indicatorType = .activity
            illustrationImageView.kf.setImage(with: URL(string: imageURL))
        } else {
            illustrationImageView.heightAnchor.constraint(equalToConstant: 0).isActive = true
        }
        if let photoURL = viewModel.photoURL {
            authorImageView.kf.indicatorType = .activity
            authorImageView.kf.setImage(with: URL(string: photoURL))
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
        authorLabel.font = UIFont.customFont(.robotoMediumFont(size: 16))
        dateLabel.font = UIFont.customFont(.robotoRegularFont(size: 14))
        titleLabel.font = UIFont.customFont(.robotoBoldFont(size: 18))
        descriptionLabel.font = UIFont.customFont(.robotoRegularFont(size: 16))
    }
    
    private func configureColor() {
        authorLabel.textColor = PaletteColors.darkGray
        dateLabel.textColor = PaletteColors.textGray
        titleLabel.textColor = PaletteColors.darkGray
        descriptionLabel.textColor = PaletteColors.textGray
        lineView.backgroundColor = UIColor.lightGray.withAlphaComponent(0.2)
    }
}
