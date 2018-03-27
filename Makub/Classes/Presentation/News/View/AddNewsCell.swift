//
//  AddNewsCell.swift
//  Makub
//
//  Created by Елена Яновская on 25.03.2018.
//  Copyright © 2018 Elena Yanovskaya. All rights reserved.
//

import Kingfisher
import UIKit

final class AddNewsCell: UICollectionViewCell, ViewModelConfigurable {
    
    @IBOutlet private var userPhoto: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.contentView.translatesAutoresizingMaskIntoConstraints = false
        let screenWidth = UIScreen.main.bounds.size.width
        widthAnchor.constraint(equalToConstant: screenWidth).isActive = true

    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        userPhoto.layer.cornerRadius = userPhoto.frame.width/2
        userPhoto.clipsToBounds = true
    }
    
    func configure(for viewModel: UserViewModel) {
        userPhoto.kf.indicatorType = .activity
        userPhoto.kf.setImage(with: URL(string: viewModel.photoURL))
    }
    
}
