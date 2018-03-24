//
//  TabBarPresentationModel.swift
//  Makub
//
//  Created by Елена Яновская on 24.03.2018.
//  Copyright © 2018 Elena Yanovskaya. All rights reserved.
//

import Foundation

final class TabBarPresentationModel: PresentationModel {
    
    // MARK: - Private Properties
    
    private let userService = ServiceLayer.shared.userService
    
    // MARK: - Public Methods
    
    func obtainUserInfo(completion: @escaping () -> Void) {
        state = .loading
        userService.obtainUserInfo { result in
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
