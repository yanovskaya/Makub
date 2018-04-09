//
//  FilterOptionsParser.swift
//  Makub
//
//  Created by Елена Яновская on 07.04.2018.
//  Copyright © 2018 Elena Yanovskaya. All rights reserved.
//

import Foundation

final class FilterPresentationModel: PresentationModel {
    
    // MARK: - Public Properties
    
    var filterViewModels: [FilterViewModel]!
    var gamesViewModels: [GameViewModel]!
    
    // MARK: - Private Properties
    
    private let gamesService = ServiceLayer.shared.gamesService
    
    // MARK: - Initialization
    
    override init() {
        super.init()
        obtainFilterOptions()
    }
    
    // MARK: - Public Methods
    
    func obtainAllGames() {
        gamesService.obtainGamesCount { result in
            switch result {
            case .serviceSuccess(let model):
                self.obtainGames(count: model!.count)
            case .serviceFailure:
                self.obtainGames()
            }
        }
    }
    
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
        let array = NSArray(contentsOfFile: Bundle.main.path(forResource: "FilterOptions", ofType: "plist")!)!
        
        for dictionary in array as! [NSDictionary] {
            let entity = Filter(info: dictionary)
            model.append(entity)
        }
        
        let optionsDictionary: NSDictionary = ["name": "Клуб", "options": ["Stylery", "Your Mom"]]
        let optionsEntity = Filter(info: optionsDictionary)
        model.append(optionsEntity)
        filterViewModels = model.compactMap { FilterViewModel($0) }
    }
    
    private func obtainGames(count: Int = 2000) {
        state = .loading
        gamesService.obtainGames(from: 1, to: count, useCache: true) { result in
            switch result {
            case .serviceSuccess(let model):
                guard let model = model else { return }
                self.gamesViewModels = model.games.compactMap { GameViewModel($0) }
                self.state = .rich
            case .serviceFailure(let error): break
                //self.state = .error(code: error.code)
                
            }
        }
    }
}
