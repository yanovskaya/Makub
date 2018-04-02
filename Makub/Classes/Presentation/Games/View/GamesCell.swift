//
//  GamesCell.swift
//  Makub
//
//  Created by Елена Яновская on 02.04.2018.
//  Copyright © 2018 Elena Yanovskaya. All rights reserved.
//

import UIKit

final class GamesCell: UITableViewCell, ViewModelConfigurable {

    // MARK: - IBOutlets
    
    @IBOutlet private var stageLabel: UILabel!
    @IBOutlet private var typeLabel: UILabel!
    
    @IBOutlet private var photo1: UIImageView!
    @IBOutlet private var photo2: UIImageView!
    @IBOutlet private var player1: UILabel!
    @IBOutlet private var player2: UILabel!
    @IBOutlet private var score1: UILabel!
    @IBOutlet private var score2: UILabel!
    
    // MARK: - View lifecycle
    
    override func awakeFromNib() {
    super.awakeFromNib()
    }
    
    // MARK: - Public Methods
    
    func configure(for viewModel: GamesViewModel) {
    }
}
