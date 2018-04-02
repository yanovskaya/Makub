//
//  GamesViewController.swift
//  Makub
//
//  Created by Елена Яновская on 02.04.2018.
//  Copyright © 2018 Elena Yanovskaya. All rights reserved.
//

import PKHUD
import UIKit

final class GamesViewController: UIViewController {
    
    private enum Constants {
        static let title = "Все игры"
        static let cellIdentifier = String(describing: GamesCell.self)
    }
    
    // MARK: - IBOutlets
    
    @IBOutlet private var navigationBar: UINavigationBar!
    @IBOutlet private var tournamentsButtonItem: UIBarButtonItem!
    @IBOutlet private var filterButtonItem: UIBarButtonItem!
    
    @IBOutlet private var gamesTableView: UITableView!
    
    // MARK: - Public Properties
    
    let presentationModel = GamesPresentationModel()
    
    // MARK: - Private Properties
    
    private let refreshControl = UIRefreshControl()
    
    // MARK: - ViewController lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        gamesTableView.dataSource = self
        gamesTableView.register(UINib(nibName: Constants.cellIdentifier, bundle: nil), forCellReuseIdentifier: Constants.cellIdentifier)
        
        bindEvents()
        presentationModel.obtainGames()
    }

    // MARK: - Private Methods
    
    private func bindEvents() {
        presentationModel.changeStateHandler = { [weak self] status in
            switch status {
            case .loading:
                HUD.show(.progress)
            case .rich:
                self?.gamesTableView.reloadData()
                HUD.hide()
            case .error (let code):
                switch code {
                case -1009, -1001:
                    HUD.show(.labeledError(title: ErrorDescription.title.rawValue, subtitle: ErrorDescription.network.rawValue))
                case 2:
                    HUD.show(.labeledError(title: ErrorDescription.title.rawValue, subtitle: ErrorDescription.recover.rawValue))
                default:
                    HUD.show(.labeledError(title: ErrorDescription.title.rawValue, subtitle: ErrorDescription.server.rawValue))
                }
                HUD.hide(afterDelay: 1.0)
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                self?.refreshControl.endRefreshing()
            }
        }
    }
    
}

extension GamesViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presentationModel.viewModels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let viewModel = presentationModel.viewModels[indexPath.row]
        let cellIdentifier = Constants.cellIdentifier
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as? GamesCell else { return UITableViewCell() }
        
        cell.configure(for: viewModel)
        cell.layoutIfNeeded()
        return cell
    }
    
}
