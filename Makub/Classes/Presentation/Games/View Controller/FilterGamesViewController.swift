//
//  FilterGamesViewController.swift
//  Makub
//
//  Created by Елена Яновская on 02.04.2018.
//  Copyright © 2018 Elena Yanovskaya. All rights reserved.
//

import UIKit

final class FilterGamesViewController: UIViewController {
    
    // MARK: - Constants
    
    private enum Constants {
        static let title = "Фильтр"
        static let filterImage = "filter"
        static let titleCellId = String(describing: TitleFilterCell.self)
        static let optionCellId = String(describing: OptionFilterCell.self)
    }
    
    // MARK: - IBOutlets
    
    @IBOutlet private var filterTableView: UITableView!
    
        // MARK: - Private Properties
    
    private let filterOptions = FilterOptionsParser.filterOptions
    private var oppenedCategories: [Int] = []
    
    // MARK: - ViewController lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        filterTableView.register(UINib(nibName: Constants.titleCellId, bundle: nil), forCellReuseIdentifier: Constants.titleCellId)
        filterTableView.register(UINib(nibName: Constants.optionCellId, bundle: nil), forCellReuseIdentifier: Constants.optionCellId)
        filterTableView.dataSource = self
        filterTableView.delegate = self
    }
}

// MARK: - UITableViewDataSource

extension FilterGamesViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return filterOptions.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return numberOfElementsInSection(section)
    }
    
    func numberOfElementsInSection(_ section: Int, allElementsToShow: Bool = false) -> Int {
        if oppenedCategories.index(of: section) != nil || allElementsToShow  {
           // print(oppenedCategories)
            return filterOptions[section].options.count + 2
        }
        return 1
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            return titleCell(tableView, cellForRowAtIndexPath: indexPath)
        default:
            return optionCell(tableView, cellForRowAtIndexPath: indexPath)
        }
    }
    
    func titleCell(_ tableView: UITableView, cellForRowAtIndexPath indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.titleCellId, for: indexPath) as! TitleFilterCell
        return cell
    }
    
    func optionCell(_ tableView: UITableView, cellForRowAtIndexPath indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.optionCellId, for: indexPath) as! OptionFilterCell
        return cell
    }
    
}

// MARK: - UITableViewDelegate

extension FilterGamesViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.beginUpdates()
        tableView.deselectRow(at: indexPath, animated: true)
        
        var indexPathes: [IndexPath] = []
        for index in 1..<numberOfElementsInSection(indexPath.section, allElementsToShow: true) {
            indexPathes.append(IndexPath(row: index, section: indexPath.section))
        }
        
        if let index = oppenedCategories.index(of: indexPath.section) {
            oppenedCategories.remove(at: index)
            tableView.deleteRows(at: indexPathes, with: UITableViewRowAnimation.fade)
        } else {
            oppenedCategories.append(indexPath.section)
            tableView.insertRows(at: indexPathes, with: UITableViewRowAnimation.fade)
        }
        
        tableView.endUpdates()
    }
    
}
