//
//  UserCell.swift
//  Makub
//
//  Created by Елена Яновская on 21.04.2018.
//  Copyright © 2018 Elena Yanovskaya. All rights reserved.
//

import UIKit

final class UserCell: UICollectionViewCell {
    
    // MARK: - Constants
    
    private enum Constants {
        static let rankImage = "rank"
    }
    
    @IBOutlet private var userImageView: UIImageView!
    @IBOutlet private var nameLabel: UILabel!
    @IBOutlet private var clubLabel: UILabel!
    @IBOutlet private var rankClassicImageView: UIImageView!
    @IBOutlet private var rankFastImageView: UIImageView!
    
    @IBOutlet private var rankClassicLabel: UILabel!
    @IBOutlet private var classicLabel: UILabel!
    @IBOutlet private var rankFastLabel: UILabel!
    @IBOutlet private var fastLabel: UILabel!
    @IBOutlet private var lineView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        rankClassicImageView.image = UIImage(named: Constants.rankImage)?.withRenderingMode(.alwaysTemplate)
        rankClassicImageView.tintColor = PaletteColors.lightGray
        rankFastImageView.image = UIImage(named: Constants.rankImage)?.withRenderingMode(.alwaysTemplate)
        rankFastImageView.tintColor = PaletteColors.lightGray
        lineView.backgroundColor = UIColor.lightGray.withAlphaComponent(0.2)
    }
}
