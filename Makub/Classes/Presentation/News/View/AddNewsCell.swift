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
    
    @IBOutlet private var userImageView: UIImageView!
    @IBOutlet private var addNewsLabel: UILabel!
    
    // MARK: - View lifecycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        configureLayout()
        configureLabel()
        
        userImageView.image = UIImage(named: Constants.userImage)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    // MARK: - Public Methods
    
    func configure(for viewModel: UserViewModel?) {
        guard let viewModel = viewModel else { return }
        let cornerRadius = userImageView.frame.width / 2
        let cornerProcessor = RoundCornerImageProcessor(cornerRadius: cornerRadius)
        let sizeProcessor = ResizingImageProcessor(referenceSize: CGSize(width: 45, height: 45), mode: .aspectFill)
        userImageView.kf.indicatorType = .activity
        userImageView.kf.setImage(with: URL(string: viewModel.photoURL), placeholder: nil, options: [.processor(cornerProcessor), .processor(sizeProcessor)])
        setNeedsLayout()
    }
    
    // MARK: - Private Methods
    
    private func configureLayout() {
        self.contentView.translatesAutoresizingMaskIntoConstraints = false
        let screenWidth = UIScreen.main.bounds.size.width
        widthAnchor.constraint(equalToConstant: screenWidth).isActive = true
    }
    
    private func configureLabel() {
        addNewsLabel.font = UIFont.customFont(.robotoRegularFont(size: 16))
        addNewsLabel.text = Constants.addNewsLabel
        addNewsLabel.textColor = PaletteColors.textGray
    }
    
}
