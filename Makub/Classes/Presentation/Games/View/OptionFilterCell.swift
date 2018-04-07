//
//  OptionFilterCell.swift
//  Makub
//
//  Created by Елена Яновская on 07.04.2018.
//  Copyright © 2018 Elena Yanovskaya. All rights reserved.
//

import UIKit

final class OptionFilterCell: UITableViewCell {
    
    @IBOutlet private var containerView: UIView!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var circleImageView: UIImageView!
    
    var initialImage: UIImage!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        circleImageView.contentMode = .scaleAspectFit
        initialImage = UIImage(color: .white, size: CGSize(width: 50, height: 50))?.drawEmptyCircle()
        
        circleImageView.image = initialImage
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        circleImageView.image = nil
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    private var chosen = false
    
    func setChosen(chosen: Bool, animated: Bool = true) {
        self.chosen = chosen
        
        let duration = animated ? 0.25 : 0
        UIView.transition(with: circleImageView,
                   duration: duration,
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
