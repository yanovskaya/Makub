//
//  GamesAchievementsCell.swift
//  Makub
//
//  Created by Елена Яновская on 21.04.2018.
//  Copyright © 2018 Elena Yanovskaya. All rights reserved.
//

import UIKit

final class GamesAchievementsCell: UICollectionViewCell, ViewModelConfigurable {
    
    // MARK: - Constants
    
    private enum Constants {
        static let common = "Общий"
        static let classic = "КУБ"
        static let fast = "БУБ"
        static let veryFast = "ББП"
        
        static let allGames = "Игры"
        static let wins = "Победы"
        static let loses = "Поражения"
    }
    
    // MARK: - IBOutlets
    
    
    @IBOutlet private var gameStatisticsView: UIView!
    
    @IBOutlet private var allGamesLabel: UILabel!
    @IBOutlet private var allGamesCountLabel: UILabel!
    
    @IBOutlet private var winCountLabel: UILabel!
    @IBOutlet private var winLabel: UILabel!
    
    @IBOutlet private var loseCountLabel: UILabel!
    @IBOutlet private var loseLabel: UILabel!
    
    @IBOutlet private var commonLabel: UILabel!
    @IBOutlet private var commonPointsLabel: UILabel!
    @IBOutlet private var commonPositionLabel: UILabel!
    
    @IBOutlet private var classicLabel: UILabel!
    @IBOutlet private var classicPointsLabel: UILabel!
    @IBOutlet private var classicPositionLabel: UILabel!
    
    @IBOutlet private var fastLabel: UILabel!
    @IBOutlet private var fastPointsLabel: UILabel!
    @IBOutlet private var fastPositionLabel: UILabel!
    
    @IBOutlet private var veryFastLabel: UILabel!
    @IBOutlet private var veryFastPointsLabel: UILabel!
    @IBOutlet private var veryFastPositionLabel: UILabel!
    
    // MARK: - View lifecycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        configureColor()
        configureFont()
        configureInitialText()
    }
    
    // MARK: - Public Methods
    
    func configure(for viewModel: UserViewModel) {
        commonPositionLabel.text = "#" + viewModel.commonPosition
        classicPositionLabel.text = "#" + viewModel.classicPosition
        fastPositionLabel.text = "#" + viewModel.fastPosition
        veryFastPositionLabel.text = "#" + viewModel.veryFastPosition
        
        commonPointsLabel.text = viewModel.commonRating
        classicPointsLabel.text = viewModel.classicRating
        fastPointsLabel.text = viewModel.fastRating
        veryFastPointsLabel.text = viewModel.veryFastRating
        
        allGamesCountLabel.text = String(viewModel.games)
        winCountLabel.text = String(viewModel.win)
        loseCountLabel.text = String(viewModel.lose)
    }
    
    func configureCellWidth(_ width: CGFloat) {
       widthAnchor.constraint(equalToConstant: width).isActive = true
    }
    
    // MARK: - Private Methods
    
    private func configureColor() {
        backgroundColor = PaletteColors.blueBackground
        
        commonPointsLabel.textColor = PaletteColors.darkGray
        classicPointsLabel.textColor = PaletteColors.darkGray
        fastPointsLabel.textColor = PaletteColors.darkGray
        veryFastPointsLabel.textColor = PaletteColors.darkGray
        
        winCountLabel.textColor = PaletteColors.darkGray
        loseCountLabel.textColor = PaletteColors.darkGray
        allGamesCountLabel.textColor = PaletteColors.darkGray
        
        commonPositionLabel.textColor = PaletteColors.textGray
        fastPositionLabel.textColor = PaletteColors.textGray
        classicPositionLabel.textColor = PaletteColors.textGray
        veryFastPositionLabel.textColor = PaletteColors.textGray
        
        commonLabel.textColor = PaletteColors.textGray
        fastLabel.textColor = PaletteColors.textGray
        veryFastLabel.textColor = PaletteColors.textGray
        classicLabel.textColor = PaletteColors.textGray
        
        winLabel.textColor = PaletteColors.textGray
        loseLabel.textColor = PaletteColors.textGray
        allGamesLabel.textColor = PaletteColors.textGray
        
        gameStatisticsView.layer.shadowOpacity = 1
        gameStatisticsView.layer.shadowOffset = CGSize(width: 0, height: 3)
        gameStatisticsView.layer.shadowColor = UIColor.black.withAlphaComponent(0.04).cgColor
        gameStatisticsView.layer.shadowRadius = 3
    }
    
    private func configureFont() {
        commonPointsLabel.font = UIFont.customFont(.robotoRegularFont(size: 15))
        fastPointsLabel.font = UIFont.customFont(.robotoRegularFont(size: 15))
        classicPointsLabel.font = UIFont.customFont(.robotoRegularFont(size: 15))
        veryFastPointsLabel.font = UIFont.customFont(.robotoRegularFont(size: 15))
        
        commonLabel.font = UIFont.customFont(.robotoRegularFont(size: 13))
        fastLabel.font = UIFont.customFont(.robotoRegularFont(size: 13))
        veryFastLabel.font = UIFont.customFont(.robotoRegularFont(size: 13))
        classicLabel.font = UIFont.customFont(.robotoRegularFont(size: 13))
        
        commonPositionLabel.font = UIFont.customFont(.robotoRegularFont(size: 14))
        classicPositionLabel.font = UIFont.customFont(.robotoRegularFont(size: 14))
        veryFastPositionLabel.font = UIFont.customFont(.robotoRegularFont(size: 14))
        fastPositionLabel.font = UIFont.customFont(.robotoRegularFont(size: 14))
        
        winLabel.font = UIFont.customFont(.robotoRegularFont(size: 15))
        allGamesLabel.font = UIFont.customFont(.robotoRegularFont(size: 15))
        loseLabel.font = UIFont.customFont(.robotoRegularFont(size: 15))
        
        winCountLabel.font = UIFont.customFont(.robotoMediumFont(size: 16))
        loseCountLabel.font = UIFont.customFont(.robotoMediumFont(size: 16))
        allGamesCountLabel.font = UIFont.customFont(.robotoMediumFont(size: 16))
    }
    
    private func configureInitialText() {
        commonLabel.text = Constants.common
        classicLabel.text = Constants.classic
        fastLabel.text = Constants.fast
        veryFastLabel.text = Constants.veryFast
        
        winLabel.text = Constants.wins
        loseLabel.text = Constants.loses
        allGamesLabel.text = Constants.allGames
    }
}
