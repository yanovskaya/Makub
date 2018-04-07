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
    
    
     var filterOptions = FilterOptionsParser.filterOptions
    var oppenedCategories: [Int] = []
    
    // MARK: - ViewController lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        filterTableView.register(UINib(nibName: Constants.titleCellId, bundle: nil), forCellReuseIdentifier: Constants.titleCellId)
        filterTableView.register(UINib(nibName: Constants.optionCellId, bundle: nil), forCellReuseIdentifier: Constants.optionCellId)
        filterTableView.dataSource = self
        filterTableView.delegate = self
    }
    var cellIsOpened = false
}

extension FilterGamesViewController: UITableViewDataSource {
    
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return filterOptions.count
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return numberOfElementsInSection(section)
    }
    
    func numberOfElementsInSection(_ section: Int, mechOppened: Bool = false) -> Int {
        if oppenedCategories.index(of: section) != nil || mechOppened  {
            return filterOptions[section].options.count + 2
        }
        return 1
    }
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell
        
        switch indexPath.row {
        case 0:
            cell = titleCell(tableView, cellForRowAtIndexPath: indexPath)
        default:
            cell = optionCell(tableView, cellForRowAtIndexPath: indexPath)
        }
        
        //let numberOfElements = numberOfElementsInSection(indexPath.section)
        return cell
    
    }
    
    func titleCell(_ tableView: UITableView, cellForRowAtIndexPath indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.titleCellId, for: indexPath) as! TitleFilterCell
        
        //cell.nameLabel.text = fil[indexPath.section].name
       // cell.selectionEnable = true
        
        return cell
    }
    
    func optionCell(_ tableView: UITableView, cellForRowAtIndexPath indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.optionCellId, for: indexPath) as! OptionFilterCell
        
        //cell.nameLabel.text = technicalSkills[indexPath.section].skills[indexPath.row - 2]
        //cell.nameLabel.textColor = UIColor.contentAdditionalElementsColor
        //cell.selectionEnable = false
        
        return cell
    }
    
}

extension FilterGamesViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let cell = tableView.cellForRow(at: indexPath) as! TitleFilterCell
        
        tableView.beginUpdates()
        tableView.deselectRow(at: indexPath, animated: true)
        
        var indexPathes: [IndexPath] = []
        for index in 1..<numberOfElementsInSection(indexPath.section, mechOppened: true) {
            print("\(index) i")
            indexPathes.append(IndexPath(row: index, section: indexPath.section))
        }
        
        if let index = oppenedCategories.index(of: indexPath.section) {
            print("второй раз щелкнуои")
            oppenedCategories.remove(at: index)
            tableView.deleteRows(at: indexPathes, with: UITableViewRowAnimation.fade)
            
//            cell.setOpened(false, animated: true, complition: { () -> () in
//                cell.roundedType = .allRounded
//            })
            
        } else {
            print("первый раз щелкнуои")
            oppenedCategories.append(indexPath.section)
            tableView.insertRows(at: indexPathes, with: UITableViewRowAnimation.fade)
            
            //cell.roundedType = .topRounded
            //cell.setOpened(true, animated: true)
        }
        
        tableView.endUpdates()
    }
    
}
