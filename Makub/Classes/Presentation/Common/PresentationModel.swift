//
//  PresentationModel.swift
//  Makub
//
//  Created by Елена Яновская on 16.03.2018.
//  Copyright © 2018 Elena Yanovskaya. All rights reserved.
//

import Foundation

// MARK: - ViewModelConfigurable

typealias ViewModel = Any

protocol ViewModelConfigurable {
    
    associatedtype ViewModelType: ViewModel
    
    func configure(for viewModel: ViewModelType)
}

// MARK: - PresentationModel

class PresentationModel {
    
    enum State {
        case rich
        case loading
        case error(code: Int)
    }
    
    typealias ChangeStateHandler = (State) -> Void
    
    var changeStateHandler: ChangeStateHandler?
    var state: State = .rich {
        didSet { changeStateHandler?(state) }
    }
}
