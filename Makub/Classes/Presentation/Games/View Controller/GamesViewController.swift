//
//  GamesViewController.swift
//  Makub
//
//  Created by Елена Яновская on 02.04.2018.
//  Copyright © 2018 Elena Yanovskaya. All rights reserved.
//

import UIKit

final class GamesViewController: UIViewController {
    
    // MARK: - IBOutlets
    
    @IBOutlet private var navigationBar: UINavigationBar!
    @IBOutlet private var tournamentsButtonItem: UIBarButtonItem!
    @IBOutlet private var filterButtonItem: UIBarButtonItem!
    
    @IBOutlet private var gamesTableView: UITableView!
    
    // MARK: - ViewController lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

}
