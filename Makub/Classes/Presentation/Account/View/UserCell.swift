//
//  UserCell.swift
//  Makub
//
//  Created by Елена Яновская on 21.04.2018.
//  Copyright © 2018 Elena Yanovskaya. All rights reserved.
//

import Kingfisher
import UIKit

final class UserCell: UICollectionViewCell, ViewModelConfigurable {
    
    // MARK: - Constants
    
    private enum Constants {
        static let classic = "К"
        static let fast = "Б"
        static let userImage = "photo_default"
        static let rankImage = "rank"
    }
    
    private enum SizeConstants {
        static let userWidth: CGFloat = 200
        static let userHeight: CGFloat = 200
    }
    
    // MARK: - IBOutlets
    
    @IBOutlet private var userImageView: UIImageView!
    @IBOutlet private var nameLabel: UILabel!
    @IBOutlet private var clubLabel: UILabel!
    @IBOutlet private var lineView: UIView!
    
    @IBOutlet private var rankClassicImageView: UIImageView!
    @IBOutlet private var rankClassicLabel: UILabel!
    @IBOutlet private var classicLabel: UILabel!
    
    @IBOutlet private var rankFastImageView: UIImageView!
    @IBOutlet private var rankFastLabel: UILabel!
    @IBOutlet private var fastLabel: UILabel!
    
    // MARK: - Private Property
    
    private let indicator = UserIndicator()
    
    // MARK: - View lifecycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        rankClassicImageView.image = UIImage(named: Constants.rankImage)?.withRenderingMode(.alwaysTemplate)
        rankClassicImageView.tintColor = PaletteColors.lightGray
        rankFastImageView.image = UIImage(named: Constants.rankImage)?.withRenderingMode(.alwaysTemplate)
        rankFastImageView.tintColor = PaletteColors.lightGray
        lineView.backgroundColor = UIColor.lightGray.withAlphaComponent(0.2)
        
        configureColor()
        configureFont()
        configureInitialText()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        userImageView.clipsToBounds = true
        userImageView.layer.cornerRadius = userImageView.frame.width / 2
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        rankFastLabel.text = nil
        rankClassicLabel.text = nil
        nameLabel.text = nil
        clubLabel.text = nil
        userImageView.image = nil
    }
    
    // MARK: - Public Methods
    
    // FIXME: refactoring
    func configure(for viewModel: UserViewModel) {
        clubLabel.text = viewModel.club
        nameLabel.text = viewModel.fullname
        if let rankClassic = viewModel.rankClassic {
            classicLabel.isHidden = false
            rankClassicLabel.isHidden = false
            rankClassicImageView.isHidden = false
            rankClassicLabel.text = rankClassic
        } else {
            classicLabel.isHidden = true
            rankClassicLabel.isHidden = true
            rankClassicImageView.isHidden = true
        }
        if let rankFast = viewModel.rankFast {
            fastLabel.isHidden = false
            rankFastLabel.isHidden = false
            rankFastImageView.isHidden = false
            rankFastLabel.text = rankFast
        } else {
            fastLabel.isHidden = true
            rankFastLabel.isHidden = true
            rankFastImageView.isHidden = true
        }
        if let photoURL = viewModel.photoURL {
            let sizeProcessor = ResizingImageProcessor(referenceSize: CGSize(width: SizeConstants.userWidth, height: SizeConstants.userHeight), mode: .aspectFill)
            userImageView.kf.indicatorType = .custom(indicator: indicator)
            userImageView.kf.setImage(with: URL(string: photoURL), placeholder: nil, options: [.processor(sizeProcessor)], completionHandler: { (image, _, _, _) in
                if image == nil {
                    self.userImageView.image = UIImage(named: Constants.userImage)
                }
            })
        } else {
            self.userImageView.image = UIImage(named: Constants.userImage)
        }
    }
    
    func configureCellWidth(_ width: CGFloat) {
        let labelMargins: CGFloat = 170
        nameLabel.widthAnchor.constraint(equalToConstant: width - labelMargins).isActive = true
    }
    
    // MARK: - Private Methods
    
    private func configureInitialText() {
        classicLabel.text = Constants.classic
        fastLabel.text = Constants.fast
    }
    
    private func configureColor() {
        classicLabel.textColor = PaletteColors.lightGray
        rankClassicLabel.textColor = PaletteColors.lightGray
        fastLabel.textColor = PaletteColors.lightGray
        rankFastLabel.textColor = PaletteColors.lightGray
        nameLabel.textColor = PaletteColors.darkGray
        clubLabel.textColor = PaletteColors.textGray
    }
    
    private func configureFont() {
        nameLabel.font = UIFont.customFont(.robotoMediumFont(size: 15))
        clubLabel.font = UIFont.customFont(.robotoRegularFont(size: 13))
        rankFastLabel.font = UIFont.customFont(.robotoRegularFont(size: 11))
        rankClassicLabel.font = UIFont.customFont(.robotoRegularFont(size: 11))
        fastLabel.font = UIFont.customFont(.robotoRegularFont(size: 11))
        classicLabel.font = UIFont.customFont(.robotoRegularFont(size: 11))
    }
    
}
