//
//  FilterGamesViewControllerDelegate.swift
//  Makub
//
//  Created by Елена Яновская on 09.04.2018.
//  Copyright © 2018 Elena Yanovskaya. All rights reserved.
//

import Foundation

protocol FilterViewControllerDelegate: class {
    
    func saveChosenOptions(_ options: [IndexPath])
    
    func obtainAllItems(parameters: [String: [String]])
    
    func showItemsWithNoFilter()
}
