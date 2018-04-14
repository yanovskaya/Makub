//
//  GameInfoViewController.swift
//  Makub
//
//  Created by Елена Яновская on 14.04.2018.
//  Copyright © 2018 Elena Yanovskaya. All rights reserved.
//

import UIKit
import YouTubePlayer

final class GameInfoViewController: UIViewController {

    // MARK: - IBOutlets
    
    @IBOutlet private var gameVideoPlayer: YouTubePlayerView!
    
    // MARK: - Public Properties
    
    let presentationModel = GameInfoPresentationModel()
    
    // MARK: - ViewController lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.isNavigationBarHidden = false
        if let video = presentationModel.gameViewModel.video {
            gameVideoPlayer.loadVideoID(video)
        }
    }
}
