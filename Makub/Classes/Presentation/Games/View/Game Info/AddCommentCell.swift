//
//  AddCommentCell.swift
//  Makub
//
//  Created by Елена Яновская on 15.04.2018.
//  Copyright © 2018 Elena Yanovskaya. All rights reserved.
//

import Kingfisher
import UIKit

final class AddCommentCell: UICollectionViewCell, ViewModelConfigurable {
    
    // MARK: - Constants
    
    private enum Constants {
        static let userImage = "photo_default"
        static let addNewsLabel = "Оставить комментарий"
    }
    
    private enum SizeConstants {
        static let userWidth: CGFloat = 200
        static let userHeight: CGFloat = 200
    }
    
    // MARK: - IBOutlets
    
    @IBOutlet private var userImageView: UIImageView!
    @IBOutlet private var newCommentLabel: UILabel!
    
    // MARK: - Private Property
    
    private let indicator = UserIndicator()
    
    // MARK: - View lifecycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        configureLabel()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        userImageView.clipsToBounds = true
        userImageView.layer.cornerRadius = userImageView.frame.width / 2
    }
    
    // MARK: - Public Methods
    
    func configure(for viewModel: UserViewModel) {
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
    
    // MARK: - Private Methods
    
    private func configureLabel() {
        newCommentLabel.textColor = PaletteColors.darkGray
        newCommentLabel.font = UIFont.customFont(.robotoRegularFont(size: 16))
        newCommentLabel.text = Constants.addNewsLabel
    }
    
}
