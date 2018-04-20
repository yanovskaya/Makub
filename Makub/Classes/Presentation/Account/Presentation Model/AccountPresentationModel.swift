//
//  AccountPresentationModel.swift
//  Makub
//
//  Created by Елена Яновская on 21.04.2018.
//  Copyright © 2018 Elena Yanovskaya. All rights reserved.
//

import Foundation

final class AccountPresentationModel: PresentationModel {
    
    // MARK: - Constants
    
    private enum Constants {
        static let resource = "Settings"
        static let type = "plist"
    }
    
    // MARK: - Public Properties
    
    var settingModels = [String]()
    var userViewModel: UserViewModel!
    
    // MARK: - Private Properties
    
    private let userService = ServiceLayer.shared.userService
    private var userCacheIsObtained = false
    
    // MARK: - Public Methods
    
    func obtainProfileWithSettings() {
        obtainSettings()
        obtainUserCache()
        obtainUserInfo()
    }
    
    // MARK: - Private Methods
    
    private func obtainSettings() {
        print("here")
        if let URL = Bundle.main.url(forResource: Constants.resource, withExtension: Constants.type) {
            print("3")
            if let settingsPlist = NSArray(contentsOf: URL) as? [String] {
                print("e 1")
                for settings in settingsPlist {
                    print("e 2")
                    settingModels.append(settings)
                }
            }
        }
    }
    
    private func obtainUserInfo() {
        if !userCacheIsObtained { state = .loading }
        userService.obtainUserInfo(useCache: true) { result in
            switch result {
            case .serviceSuccess(let model):
                guard let model = model else { return }
                self.userViewModel = UserViewModel(model)
                self.state = .rich
            case .serviceFailure(let error):
                self.state = .error(code: error.code)
            }
        }
    }
    
    private func obtainUserCache() {
        userService.obtainRealmCache(error: nil) { result in
            switch result {
            case .serviceSuccess(let model):
                guard let model = model else { return }
                self.userViewModel = UserViewModel(model)
                self.state = .rich
                self.userCacheIsObtained = true
            case .serviceFailure:
                break
            }
        }
    }
}
