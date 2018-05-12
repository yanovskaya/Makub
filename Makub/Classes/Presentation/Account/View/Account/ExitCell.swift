//
//  ExitCell.swift
//  Makub
//
//  Created by Елена Яновская on 21.04.2018.
//  Copyright © 2018 Elena Yanovskaya. All rights reserved.
//

import UIKit

final class ExitCell: UICollectionViewCell {
    
    // MARK: - Constants
    
    private enum Constants {
        static let exit = "Выйти"
    }
    
    // MARK: - IBOutlets
    
    @IBOutlet private var exitLabel: UILabel!
    
    // MARK: - View lifecycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
         configureLabel()
    }
    
    // MARK: - Private Method
    
    private func configureLabel() {
        exitLabel.text = Constants.exit
        exitLabel.textColor = PaletteColors.exit
        exitLabel.font = UIFont.customFont(.robotoMediumFont(size: 16))
    }
}
