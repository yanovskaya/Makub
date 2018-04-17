//
//  FilterGamesPresentationModel.swift
//  Makub
//
//  Created by Елена Яновская on 07.04.2018.
//  Copyright © 2018 Elena Yanovskaya. All rights reserved.
//

import Foundation

final class FilterGamesPresentationModel: PresentationModel {
    
    // MARK: - Constants
    
    private enum Constants {
        static let resource = "FilterOptions"
        static let type = "plist"
        
        static let clubKey = "Клуб"
    }
    
    // MARK: - Public Properties
    
    var filterViewModels: [FilterGamesViewModel]!
    var clubViewModels: [ClubViewModel]! {
        didSet {
            obtainFilterOptions()
        }
    }
    
    // MARK: - Private Properties
    
    private let gamesService = ServiceLayer.shared.gamesService
    
    // MARK: - Public Methods
    
    func prepareFilterConditions(for indexPathArray: [IndexPath]) -> [String: [String]] {
        var dictionary = [String: [String]]()
        for indexPath in indexPathArray {
            let key = filterViewModels[indexPath.section].name
            let value = filterViewModels[indexPath.section].options[indexPath.row - 1]
            if dictionary[key] != nil {
            dictionary[key]!.append(value)
            } else {
                dictionary[key] = [value]
            }
        }
        return dictionary
    }
    
    // MARK: - Private Methods
    
    private func obtainFilterOptions() {
        var model = [Filter]()
        let array = NSArray(contentsOfFile: Bundle.main.path(forResource: Constants.resource, ofType: Constants.type)!)!
        
        for dictionary in array as! [NSDictionary] {
            let entity = Filter(info: dictionary)
            model.append(entity)
        }
        
        let clubsDictionary = clubViewModels.compactMap { $0.name }
        let clubsOptions: NSDictionary = ["name": Constants.clubKey,
                                          "options": clubsDictionary]
        let clubsEntity = Filter(info: clubsOptions)
        model.insert(clubsEntity, at: model.count - 1)
        filterViewModels = model.compactMap { FilterGamesViewModel($0) }
    }
}
