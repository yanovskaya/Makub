//
//  SettingCell.swift
//  Makub
//
//  Created by Елена Яновская on 21.04.2018.
//  Copyright © 2018 Elena Yanovskaya. All rights reserved.
//

import UIKit

class SettingCell: UICollectionViewCell {
    
    @IBOutlet private var lineView: UIView!
    @IBOutlet var lineViewHeight: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        lineView.backgroundColor = UIColor.lightGray.withAlphaComponent(0.1)
    }
    
    func configureSeperator(hide: Bool = false) {
        if hide {
            lineViewHeight.constant = 0
        } else {
            lineViewHeight.constant = 1
        }
    }
}
