//
//  TournamentCell.swift
//  Makub
//
//  Created by Елена Яновская on 18.04.2018.
//  Copyright © 2018 Elena Yanovskaya. All rights reserved.
//

import UIKit

final class TournamentCell: UICollectionViewCell, ViewModelConfigurable {
    
    // MARK: - Constants
    
    private enum Constants {
        static let whenLabel = "Когда:"
        static let whereLabel = "Где:"
    }
    
    // MARK: - IBOutlets
    
    @IBOutlet private var statusLabel: UILabel!
    @IBOutlet private var typeLabel: UILabel!
    @IBOutlet private var nameLabel: UILabel!
    @IBOutlet private var descriptionLabel: UILabel!
    @IBOutlet private var whenLabel: UILabel!
    @IBOutlet private var whereLabel: UILabel!
    @IBOutlet private var dateLabel: UILabel!
    @IBOutlet private var placeLabel: UILabel!
    
    @IBOutlet var distanceBetweenInfo: NSLayoutConstraint!
    @IBOutlet var distanceBetweenTitles: NSLayoutConstraint!
    // MARK: - View lifecycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        initialConfigureText()
        configureFont()
        configureColor()
    }
    
    // MARK: - Prepare for Reuse
    
    override func prepareForReuse() {
        super.prepareForReuse()
        nameLabel.text = nil
        typeLabel.text = nil
        statusLabel.text = nil
        descriptionLabel.text = nil
        dateLabel.text = nil
        placeLabel.text = nil
        whereLabel.text = Constants.whereLabel
        backgroundColor = .white
        
    }
    
    // MARK: - Public Methods
    
    func configure(for viewModel: TournamentViewModel) {
        nameLabel.text = viewModel.name
        dateLabel.text = viewModel.date
        typeLabel.text = viewModel.type
        statusLabel.text = viewModel.status
        if let description = viewModel.description {
        descriptionLabel.text = description
            distanceBetweenTitles.constant = 8
        } else {
            descriptionLabel.text = ""
            distanceBetweenTitles.constant = 0
        }
        if let place = viewModel.place {
            placeLabel.text = place
            whereLabel.text = Constants.whereLabel
            distanceBetweenInfo.constant = 8
        } else {
            placeLabel.text = ""
            whereLabel.text = ""
            distanceBetweenInfo.constant = 0
        }
        switch viewModel.period {
        case .future:
            backgroundColor = PaletteColors.blueTint.withAlphaComponent(0.1)
        case .past:
            backgroundColor = .white
        }
    }
    
    func configureCellWidth(_ width: CGFloat) {
         nameLabel.widthAnchor.constraint(equalToConstant: width - 14 * 2 - 5 * 2).isActive = true
        if let placeLabel = placeLabel {
            placeLabel.widthAnchor.constraint(equalToConstant: width * 3 / 4).isActive = true
        }
    }
    
    // MARK: - Private Methods
    
    private func initialConfigureText() {
        whenLabel.text = Constants.whenLabel
    }
    
    private func configureFont() {
        statusLabel.font = UIFont.customFont(.robotoRegularFont(size: 12))
        typeLabel.font = UIFont.customFont(.robotoRegularFont(size: 12))
        nameLabel.font = UIFont.customFont(.robotoRegularFont(size: 16))
        descriptionLabel.font = UIFont.customFont(.robotoRegularFont(size: 15))
        whenLabel.font = UIFont.customFont(.robotoMediumFont(size: 14))
        whereLabel.font = UIFont.customFont(.robotoMediumFont(size: 14))
        dateLabel.font = UIFont.customFont(.robotoRegularFont(size: 14))
        placeLabel.font = UIFont.customFont(.robotoRegularFont(size: 14))
        
        placeLabel.setLineSpacing(lineSpacing: 3)
        nameLabel.setLineSpacing(lineSpacing: 3)
        descriptionLabel.setLineSpacing(lineSpacing: 4)
    }
    
    private func configureColor() {
        statusLabel.textColor = PaletteColors.textGray
        typeLabel.textColor = PaletteColors.textGray
        nameLabel.textColor = PaletteColors.darkGray
        descriptionLabel.textColor = PaletteColors.textGray
        whenLabel.textColor = PaletteColors.darkGray
        whereLabel.textColor = PaletteColors.darkGray
        dateLabel.textColor = PaletteColors.textGray
        placeLabel.textColor = PaletteColors.textGray
    }
}
