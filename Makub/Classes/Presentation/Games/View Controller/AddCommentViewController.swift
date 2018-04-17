//
//  AddCommentViewController.swift
//  Makub
//
//  Created by Елена Яновская on 16.04.2018.
//  Copyright © 2018 Elena Yanovskaya. All rights reserved.
//

import UIKit

final class AddCommentViewController: UIViewController {
    
    // MARK: - Constants
    
    private enum Constants {
        static let title = "Комментарий"
        static let cancelButtonItem = "Отмена"
        static let doneButtonItem = "Готово"
        static let pkhudTitle = "Подождите"
        static let pkhudSubtitle = "Публикуем новость"
        
        static let userImage = "photo_default"
    }
    
    @IBOutlet private var authorImageView: UIImageView!
    @IBOutlet private var addCommentLabel: UILabel!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
    }

}
