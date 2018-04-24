//
//  UserCommentsPresentationModel.swift
//  Makub
//
//  Created by Елена Яновская on 25.04.2018.
//  Copyright © 2018 Elena Yanovskaya. All rights reserved.
//

import Foundation
import UIKit

final class UserCommentsPresentationModel: PresentationModel {
    
    // MARK: - Public Properties
    
    var userViewModel: UserViewModel!
    var commentsViewModels = [CommentViewModel]()
    var title: String!
    
    // MARK: - Private Properties
    
    private let accountService = ServiceLayer.shared.accountService
    private let fromParameter = 0
    
    // MARK: - Public Methods
    
    func obtainAllComments() {
        state = .loading
        accountService.obtainUserCommentsCount { result in
            switch result {
                case .serviceSuccess(let model):
                    guard let model = model else { return }
                    self.obtainComments(count: model.count)
            case .serviceFailure:
                self.obtainComments()
            }
        }
    }
    
    func refreshAllComments() {
        state = .loading
        accountService.obtainUserCommentsCount { result in
            switch result {
            case .serviceSuccess(let model):
                guard let model = model else { return }
                self.obtainComments(count: model.count, useCache: false)
            case .serviceFailure(let error):
                self.state = .error(code: error.code)
            }
        }
    }
    // MARK: - Private Methods
    
    private func obtainComments(count: Int = 50, useCache: Bool = true) {
        guard let id = Int(userViewModel.id) else { return }
        accountService.obtainUserComments(id: id, from: fromParameter, to: count, useCache: useCache) { result in
            switch result {
            case .serviceSuccess(let model):
                guard let model = model else { return }
                self.commentsViewModels = model.comments.compactMap { CommentViewModel($0) }
                self.state = .rich
            case .serviceFailure(let error):
                self.state = .error(code: error.code)
            }
        }
    }
}
