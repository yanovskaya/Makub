//
//  OptionFilterCell.swift
//  Makub
//
//  Created by Елена Яновская on 07.04.2018.
//  Copyright © 2018 Elena Yanovskaya. All rights reserved.
//

import UIKit

final class OptionFilterCell: UITableViewCell {
    
    // MARK: - Constants
    
    private enum Constants {
        static let circleImage = "circle"
    }
    
    @IBOutlet private var containerView: UIView!
    @IBOutlet var titleLabel: NSLayoutConstraint!
    @IBOutlet var circleImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        isUserInteractionEnabled = false
        circleImageView.contentMode = .scaleAspectFit
        circleImageView.image = UIImage(named: Constants.circleImage)?.withRenderingMode(.alwaysTemplate)
        circleImageView.tintColor = PaletteColors.textGray
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
