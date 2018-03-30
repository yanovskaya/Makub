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
    
    // MARK: - Constants
    
    private enum Constants {
        static let userImage = "user"
        static let addNewsLabel = "Создать новую запись"
    }
    
    // MARK: - IBOutlets
    
    @IBOutlet private var userPhoto: UIImageView!
    @IBOutlet private var addNewsLabel: UILabel!
    
    // MARK: - View lifecycle
    
    override func awakeFromNib() {
        configureLayout()
        configureLabel()
        
        userPhoto.image = UIImage(named: Constants.userImage)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        userPhoto.layer.cornerRadius = userPhoto.frame.width / 2
        userPhoto.clipsToBounds = true
    }
    
    // MARK: - Public Methods
    
    func configure(for viewModel: UserViewModel?) {
        guard let viewModel = viewModel else { return }
        userPhoto.kf.indicatorType = .activity
        userPhoto.kf.setImage(with: URL(string: viewModel.photoURL))
    }
    
    // MARK: - Private Methods
    
    private func configureLayout() {
        self.contentView.translatesAutoresizingMaskIntoConstraints = false
        let screenWidth = UIScreen.main.bounds.size.width
        widthAnchor.constraint(equalToConstant: screenWidth).isActive = true
    }
    
    private func configureLabel() {
        addNewsLabel.font = UIFont.customFont(.robotoRegularFont(size: 18))
        addNewsLabel.text = Constants.addNewsLabel
        addNewsLabel.textColor = PaletteColors.textGray
    }
    
}
