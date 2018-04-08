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
    
    private let presentationModel = FilterPresentationModel()
    
    private var oppenedCategories: [Int] = []
    private var chosenOptions: [IndexPath] = []
    private var selectedOptionsInSection = [Int: Int]()
    
    // MARK: - ViewController lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = PaletteColors.blueBackground
        configureTableView()
    }
    
    // MARK: - Private Methods
    
    private func configureTableView() {
        filterTableView.dataSource = self
        filterTableView.delegate = self
        filterTableView.register(UINib(nibName: Constants.titleCellId, bundle: nil), forCellReuseIdentifier: Constants.titleCellId)
        filterTableView.register(UINib(nibName: Constants.optionCellId, bundle: nil), forCellReuseIdentifier: Constants.optionCellId)
        
        filterTableView.backgroundColor = .clear
        filterTableView.tableFooterView = UIView()
        filterTableView.separatorStyle = .none
        filterTableView.rowHeight = UITableViewAutomaticDimension
        filterTableView.alwaysBounceVertical = false
    }
}

// MARK: - UITableViewDataSource

extension FilterGamesViewController: UITableViewDataSource {
    
    // MARK: - Public Methods
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return presentationModel.viewModels.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return numberOfElementsInSection(section)
    }
    
    func numberOfElementsInSection(_ section: Int, allElementsToShow: Bool = false) -> Int {
        if oppenedCategories.index(of: section) != nil || allElementsToShow {
            return presentationModel.viewModels[section].options.count + 1
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
    
    // MARK: - Private Methods
    
    private func titleCell(_ tableView: UITableView, cellForRowAtIndexPath indexPath: IndexPath) -> UITableViewCell {
        guard let titleCell = tableView.dequeueReusableCell(withIdentifier: Constants.titleCellId, for: indexPath) as? TitleFilterCell else { return UITableViewCell() }
        titleCell.selectionStyle = .none
        let viewModel = presentationModel.viewModels[indexPath.section]
        titleCell.configure(for: viewModel)
        
        if let count = selectedOptionsInSection[indexPath.section] {
            titleCell.configureDescription(with: count)
        } else {
            titleCell.configureDescription(with: 0)
        }
        return titleCell
    }
    
    private func optionCell(_ tableView: UITableView, cellForRowAtIndexPath indexPath: IndexPath) -> UITableViewCell {
        guard let optionCell = tableView.dequeueReusableCell(withIdentifier: Constants.optionCellId, for: indexPath) as? OptionFilterCell else { return UITableViewCell() }
        optionCell.selectionStyle = .none
        if chosenOptions.index(of: indexPath) != nil {
            optionCell.setChosen(chosen: true, animated: false)
        } else {
            optionCell.setChosen(chosen: false, animated: false)
        }
        let viewModel = presentationModel.viewModels[indexPath.section].options[indexPath.row - 1]
        optionCell.configure(for: viewModel)
        return optionCell
    }
    
}

// MARK: - UITableViewDelegate

extension FilterGamesViewController: UITableViewDelegate {
    
    // MARK: - Public Methods
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            titleCell(tableView, didSelectRowAt: indexPath)
        } else {
            optionCell(tableView, didSelectRowAt: indexPath)
        }
    }
    
    // MARK: - Methods for Header & Footer
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return UIView().fill { $0.backgroundColor = PaletteColors.blueBackground }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        if section == presentationModel.viewModels.count - 1 {
            return UIView().fill { $0.backgroundColor = PaletteColors.blueBackground }
        } else { return nil }
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if section == presentationModel.viewModels.count - 1 {
            return 10
        } else { return 0 }
    }
    
    // MARK: - Private Methods
    
    private func titleCell(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
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
    }
    
    private func optionCell(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let optionCell = tableView.cellForRow(at: indexPath) as? OptionFilterCell else { return }
        if let index = chosenOptions.index(of: indexPath) {
            if let count = selectedOptionsInSection[indexPath.section] {
                selectedOptionsInSection[indexPath.section] = count - 1
            }
            optionCell.setChosen(chosen: false)
            chosenOptions.remove(at: index)
        } else {
            if let count = selectedOptionsInSection[indexPath.section] {
                selectedOptionsInSection[indexPath.section] = count + 1
            } else {
                selectedOptionsInSection[indexPath.section] = 1
            }
            optionCell.setChosen(chosen: true)
            chosenOptions.append(indexPath)
        }
        let indexPath = IndexPath(item: 0, section: indexPath.section)
        tableView.reloadRows(at: [indexPath], with: .none)
    }
    
}
