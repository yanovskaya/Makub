//
//  GamesCell.swift
//  Makub
//
//  Created by Елена Яновская on 02.04.2018.
//  Copyright © 2018 Elena Yanovskaya. All rights reserved.
//

import UIKit

final class GamesCell: UITableViewCell, ViewModelConfigurable {

    override func awakeFromNib() {
    super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
    }
    
    func configure(for viewModel: CurrencyRateViewModel) {
    }
}
