//
//  FilterGamesViewControllerDelegate.swift
//  Makub
//
//  Created by Елена Яновская on 09.04.2018.
//  Copyright © 2018 Elena Yanovskaya. All rights reserved.
//

import Foundation

protocol FilterGamesViewControllerDelegate: class {
    
    func saveChosenOptions(_ options: [IndexPath])
    
    func obtainAllGames(parameters: [String: [String]])
    
    func showGamesWithNoFilter()
}
