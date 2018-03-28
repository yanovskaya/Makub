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
    
    @IBOutlet private var author: UILabel!
    @IBOutlet private var authorPhoto: UIImageView!
    @IBOutlet private var date: UILabel!
    @IBOutlet private var illustration: UIImageView!
    @IBOutlet private var title: UILabel!
    @IBOutlet private var descriptionText: UILabel!
    
    // MARK: - View lifecycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        configureLayout()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        authorPhoto.layer.cornerRadius = authorPhoto.frame.width/2
        authorPhoto.clipsToBounds = true
    }
    
    // MARK: - Public Methods
    
    func configure(for viewModel: NewsViewModel) {
        date.text = viewModel.date
        title.text = viewModel.title
        descriptionText.text = viewModel.text
        
        if let fullname = viewModel.fullName {
            author.text = fullname
        } else {
            author.removeFromSuperview()
        }
        if let imageURL = viewModel.imageURL {
            illustration.kf.indicatorType = .activity
            illustration.kf.setImage(with: URL(string: imageURL))
        } else {
            illustration.heightAnchor.constraint(equalToConstant: 0).isActive = true
        }
        if let photoURL = viewModel.photoURL {
            authorPhoto.kf.indicatorType = .activity
            authorPhoto.kf.setImage(with: URL(string: photoURL))
        } else {
            authorPhoto.image = UIImage(named: Constants.userImage)
        }
    }
    
    // MARK: - Private Methods
    
    private func configureLayout() {
        self.contentView.translatesAutoresizingMaskIntoConstraints = false
        let screenWidth = UIScreen.main.bounds.size.width
        widthAnchor.constraint(equalToConstant: screenWidth).isActive = true
    }
}
