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
    private var chosenOptions : [IndexPath] = []
    
    // MARK: - ViewController lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = PaletteColors.blueBackground
        
        filterTableView.register(UINib(nibName: Constants.titleCellId, bundle: nil), forCellReuseIdentifier: Constants.titleCellId)
        filterTableView.register(UINib(nibName: Constants.optionCellId, bundle: nil), forCellReuseIdentifier: Constants.optionCellId)
        filterTableView.dataSource = self
        filterTableView.delegate = self
        filterTableView.backgroundColor = .clear
        filterTableView.tableFooterView = UIView()
        filterTableView.separatorStyle = .none
        filterTableView.rowHeight = UITableViewAutomaticDimension
        filterTableView.alwaysBounceVertical = false
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
        if oppenedCategories.index(of: section) != nil || allElementsToShow {
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
        guard let titleCell = tableView.dequeueReusableCell(withIdentifier: Constants.titleCellId, for: indexPath) as? TitleFilterCell else { return UITableViewCell() }
        titleCell.selectionStyle = .none
        return titleCell
    }
    
    func optionCell(_ tableView: UITableView, cellForRowAtIndexPath indexPath: IndexPath) -> UITableViewCell {
        guard let optionCell = tableView.dequeueReusableCell(withIdentifier: Constants.optionCellId, for: indexPath) as? OptionFilterCell else { return UITableViewCell() }
        optionCell.selectionStyle = .none
        if chosenOptions.index(of: indexPath) != nil {
            optionCell.setChosen(chosen: true, animated: false)
        } else {
            optionCell.setChosen(chosen: false, animated: false)
        }
        return optionCell
    }
    
}

// MARK: - UITableViewDelegate

extension FilterGamesViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            guard let titleCell = tableView.cellForRow(at: indexPath) as? TitleFilterCell else { return }
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
            titleCell.setOpened()
            tableView.endUpdates()
        } else {
            guard let optionCell = tableView.cellForRow(at: indexPath) as? OptionFilterCell else { return }
            if let index = chosenOptions.index(of: indexPath) {
                optionCell.setChosen(chosen: false)
                chosenOptions.remove(at: index)
            } else {
                optionCell.setChosen(chosen: true)
                chosenOptions.append(indexPath)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return UIView().fill { $0.backgroundColor = PaletteColors.blueBackground }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10
    }
    
}
