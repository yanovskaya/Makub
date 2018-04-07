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
    
    var initialImage: UIImage!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        circleImageView.contentMode = .scaleAspectFit
        initialImage = UIImage(color: .white, size: CGSize(width: 50, height: 50))?.drawEmptyCircle()
        
        circleImageView.image = initialImage
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    private var chosen = false
    
    func setChosen() {
        chosen = !chosen

        UIView.transition(with: circleImageView,
                   duration: 0.25,
                   options: .transitionCrossDissolve,
                   animations: { self.chooseAction() })
    }
    
    
    private func chooseAction() {
        if chosen {
            circleImageView.image = initialImage?.drawFilledCircle()
        } else {
            circleImageView.image = initialImage
        }
    }
    
}
