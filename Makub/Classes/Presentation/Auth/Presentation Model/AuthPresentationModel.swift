//
//  AuthPresentationModel.swift
//  Makub
//
//  Created by Елена Яновская on 16.03.2018.
//  Copyright © 2018 Elena Yanovskaya. All rights reserved.
//

import Foundation

final class AuthPresentationModel: PresentationModel {
    
    // MARK: - Private Properties
    
    private let authorizationService = ServiceLayer.shared.authService
    
    // MARK: - Public Methods
    
    func authorizeUser(inputValues: [String], completion: @escaping () -> Void) {
        state = .loading
        authorizationService.authorizeUser(inputValues: inputValues) { result in
            switch result {
            case .serviceSuccess:
                self.state = .rich
                completion()
            case .serviceFailure(let error):
                self.state = .error(code: error.code)
            }
        }
    }
    
}
