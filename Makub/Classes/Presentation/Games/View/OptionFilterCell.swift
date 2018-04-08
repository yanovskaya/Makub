//
//  OptionFilterCell.swift
//  Makub
//
//  Created by Елена Яновская on 07.04.2018.
//  Copyright © 2018 Elena Yanovskaya. All rights reserved.
//

import UIKit

final class OptionFilterCell: UITableViewCell {
    
    // MARK: - IBOutlets

    @IBOutlet private var optionLabel: UILabel!
    @IBOutlet private var circleImageView: UIImageView!
    
    // MARK: - Private Property
    
    private var initialImage: UIImage!
    private var chosen = false
    
    // MARK: - View lifecycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        configureImageView()
    }
    
    // MARK: - Prepare for Reuse
    
    override func prepareForReuse() {
        super.prepareForReuse()
        circleImageView.image = nil
        optionLabel.text = nil
    }
    
    // MARK: - Public Methods
    
    func setChosen(chosen: Bool, animated: Bool = true) {
        self.chosen = chosen
        
        let duration = animated ? 0.25 : 0
        UIView.transition(with: circleImageView,
                   duration: duration,
                   options: .transitionCrossDissolve,
                   animations: { self.chooseAction() })
    }
    
    func configure(for option: String) {
        optionLabel.text = option
    }
    
    // MARK: - Private Methods
    
    private func configureImageView() {
        circleImageView.contentMode = .scaleAspectFit
        initialImage = UIImage(color: .white, size: CGSize(width: 50, height: 50))?.drawEmptyCircle()
        
        circleImageView.image = initialImage
    }
    
    private func chooseAction() {
        if chosen {
            circleImageView.image = initialImage?.drawFilledCircle()
        } else {
            circleImageView.image = initialImage
        }
    }
    
}
