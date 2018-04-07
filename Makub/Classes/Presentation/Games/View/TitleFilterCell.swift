//
//  TitleFilterCell.swift
//  Makub
//
//  Created by Елена Яновская on 07.04.2018.
//  Copyright © 2018 Elena Yanovskaya. All rights reserved.
//

import UIKit

final class TitleFilterCell: UITableViewCell {
    
    // MARK: - Constants
    
    private enum Constants {
        static let arrowImage = "down_arrow"
    }

    @IBOutlet private var containerView: UIView!
    @IBOutlet var arrowImageView: UIImageView!
    @IBOutlet var titleLabel: UILabel!
    
    @IBOutlet var optionSetLabel: UILabel!
    
    @IBOutlet var lineView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        arrowImageView.image = UIImage(named: Constants.arrowImage)?.withRenderingMode(.alwaysTemplate)
        arrowImageView.tintColor = PaletteColors.darkGray
        arrowImageView.contentMode = .scaleAspectFit
        lineView.backgroundColor = .clear
    }
    
    private var opened = false
    
    func setOpened() {
        opened = !opened
        
        changeLineView()
        UIView.animate(withDuration: 0.25, animations: { () -> Void in
            self.rotateAction()
        })
    }
    
    
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
    
}
