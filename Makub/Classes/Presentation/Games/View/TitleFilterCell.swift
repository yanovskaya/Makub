//
//  TitleFilterCell.swift
//  Makub
//
//  Created by Елена Яновская on 07.04.2018.
//  Copyright © 2018 Elena Yanovskaya. All rights reserved.
//

import UIKit

final class TitleFilterCell: UITableViewCell, ViewModelConfigurable {
    
    // MARK: - Constants
    
    private enum Constants {
        static let arrowImage = "down_arrow"
    }

    // MARK: - IBOutlets
    
    @IBOutlet private var arrowImageView: UIImageView!
    @IBOutlet private var lineView: UIView!
    
    @IBOutlet private var titleLabel: UILabel!
    @IBOutlet private var descriptionLabel: UILabel!
    
    // MARK: - Private Property
    
    private var opened = false
    
    // MARK: - View lifecycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        lineView.backgroundColor = .clear
        configureImageView()
        configureLabels()
    }
    
    // MARK: - Prepare for Reuse
    
    override func prepareForReuse() {
        super.prepareForReuse()
        titleLabel.text = nil
        descriptionLabel.text = nil
    }
    
    // MARK: - Public Methods
    
    func configure(for viewModel: FilterViewModel) {
        titleLabel.text = viewModel.name
    }
    
    func configureDescription(with count: Int) {
        if count > 0 {
        descriptionLabel.text = String(count)
        } else {
            descriptionLabel.text = ""
        }
    }
    
    func setOpened() {
        opened = !opened
        
        changeLineView()
        UIView.animate(withDuration: 0.25, animations: { () -> Void in
            self.rotateAction()
        })
    }
    
    // MARK: - Private Methods
    
    private func rotateAction() {
        if opened {
            arrowImageView.transform = CGAffineTransform(rotationAngle: CGFloat(-Double.pi / 2))
        } else {
            arrowImageView.transform = CGAffineTransform(rotationAngle: CGFloat(0))
        }
    }
    
    private func changeLineView() {
        if opened {
            lineView.backgroundColor = UIColor.lightGray.withAlphaComponent(0.2)
        } else {
            lineView.backgroundColor = .clear
        }
    }
    
    private func configureImageView() {
        arrowImageView.image = UIImage(named: Constants.arrowImage)?.withRenderingMode(.alwaysTemplate)
        arrowImageView.tintColor = PaletteColors.darkGray
        arrowImageView.contentMode = .scaleAspectFit
    }
    
    private func configureLabels() {
        titleLabel.font = UIFont.customFont(.robotoRegularFont(size: 16))
        titleLabel.textColor = PaletteColors.darkGray
        
        descriptionLabel.font = UIFont.customFont(.robotoRegularFont(size: 16))
        descriptionLabel.textColor = PaletteColors.textGray
    }
    
}
