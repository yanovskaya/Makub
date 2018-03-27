//
//  NewsCell.swift
//  Makub
//
//  Created by Елена Яновская on 25.03.2018.
//  Copyright © 2018 Elena Yanovskaya. All rights reserved.
//

import UIKit

class NewsCell: UICollectionViewCell, ViewModelConfigurable {
    
    // MARK: - IBOutlets
    
    @IBOutlet private var author: UILabel!
    @IBOutlet var authorPhoto: UIImageView!
    @IBOutlet private var date: UILabel!
    @IBOutlet private var illustration: UIImageView!
    @IBOutlet private var title: UILabel!
    @IBOutlet private var descriptionText: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.contentView.translatesAutoresizingMaskIntoConstraints = false
        let screenWidth = UIScreen.main.bounds.size.width
        widthAnchor.constraint(equalToConstant: screenWidth).isActive = true
    }
    
    func configure(for viewModel: NewsViewModel) {
        if let fullname = viewModel.fullName {
            author.text = fullname
        } else {
            author.removeFromSuperview()
        }
        if let image = viewModel.imageURL{
            //author.text = fullname
        } else {
            illustration.heightAnchor.constraint(equalToConstant: 0).isActive = true
        }
        date.text = viewModel.date
        title.text = viewModel.title
        descriptionText.text = viewModel.text
        
    }
    
}
