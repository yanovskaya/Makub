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
        static let addNewsLabel = "Новая запись"
    }
    
    private enum SizeConstants {
        static let userWidth: CGFloat = 135
        static let userHeight: CGFloat = 135
    }
    
    private let indicator = UserIndicator()
    
    // MARK: - IBOutlets
    
    @IBOutlet private var userImageView: UIImageView!
    @IBOutlet private var newCommentLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        newCommentLabel.text = Constants.addNewsLabel
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        userImageView.clipsToBounds = true
        userImageView.layer.cornerRadius = userImageView.frame.width / 2
    }
    
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
    
}
