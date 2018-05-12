//
//  RecoverPresentationModel.swift
//  Makub
//
//  Created by Елена Яновская on 20.03.2018.
//  Copyright © 2018 Elena Yanovskaya. All rights reserved.
//

import Foundation

final class RecoverPresentationModel: PresentationModel {
    
    // MARK: - Private Properties
    
    private let authService = ServiceLayer.shared.authService
    
    // MARK: - Public Methods
    
    func recoverPassword(email: String) {
        state = .loading
        authService.recoverPassword(email: email) { result in
            switch result {
            case .serviceSuccess:
                self.state = .rich
            case .serviceFailure(let error):
                self.state = .error(code: error.code)
            }
        }
    }
    
}
