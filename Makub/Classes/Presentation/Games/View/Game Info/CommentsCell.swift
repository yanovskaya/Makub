//
//  CommentsCell.swift
//  Makub
//
//  Created by Елена Яновская on 15.04.2018.
//  Copyright © 2018 Elena Yanovskaya. All rights reserved.
//

import Kingfisher
import UIKit

final class CommentsCell: UICollectionViewCell, ViewModelConfigurable {
    
    
    // MARK: - Constants
    
    private enum Constants {
        static let userImage = "photo_default"
    }
    
    private enum SizeConstants {
        static let userWidth: CGFloat = 135
        static let userHeight: CGFloat = 135
    }
    
    private let indicator = UserIndicator()
    
    // MARK: - IBOutlets
    
    @IBOutlet private var authorImageView: UIImageView!
    @IBOutlet private var authorLabel: UILabel!
    @IBOutlet private var clubLabel: UILabel!
    @IBOutlet private var commentLabel: UILabel!
    @IBOutlet private var dateLabel: UILabel!
    @IBOutlet private var moreButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configure(for viewModel: CommentViewModel) {
        authorLabel.text = viewModel.author
        dateLabel.text = viewModel.time
        commentLabel.text = viewModel.comment
        
        if let photoURL = viewModel.photoURL {
            let sizeProcessor = ResizingImageProcessor(referenceSize: CGSize(width: SizeConstants.userWidth, height: SizeConstants.userHeight), mode: .aspectFill)
            authorImageView.kf.indicatorType = .custom(indicator: indicator)
            authorImageView.kf.setImage(with: URL(string: photoURL), placeholder: nil, options: [.processor(sizeProcessor)], completionHandler: { (image, _, _, _) in
                if image == nil {
                    self.authorImageView.image = UIImage(named: Constants.userImage)
                }
            })
        } else {
            self.authorImageView.image = UIImage(named: Constants.userImage)
        }
    }
}
