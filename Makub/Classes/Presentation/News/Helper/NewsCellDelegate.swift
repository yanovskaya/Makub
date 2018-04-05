//
//  NewsCellDelegate.swift
//  Makub
//
//  Created by Елена Яновская on 05.04.2018.
//  Copyright © 2018 Elena Yanovskaya. All rights reserved.
//

import Foundation

protocol NewsCellDelegate: class {
    //func configureMoreButton
    func moreButtonTapped(_ sender: NewsCell)
}
