//
//  AddNewsCell.swift
//  Makub
//
//  Created by Елена Яновская on 25.03.2018.
//  Copyright © 2018 Elena Yanovskaya. All rights reserved.
//

import UIKit

final class AddNewsCell: UICollectionViewCell, ViewModelConfigurable {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.contentView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func configure(for viewModel: NewsViewModel) {
        
    }
    
}
