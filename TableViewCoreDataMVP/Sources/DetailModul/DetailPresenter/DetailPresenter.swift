//
//  DetailPresenter.swift
//  TableViewCoreDataMVP
//
//  Created by 1234 on 27.11.2023.
//

import Foundation

// MARK: - Detail Presenter Protocol

protocol DetailPresenterType {
    var user: User? { get set }
    var view: UserViewProtocol? { get set }
    func updateUser(
        user: User, avatar: Data?,
        name: String?,
        dateOfBirth: String?,
        gender: String?)
}

// MARK: - Detail Presenter

class DetailPresenter: DetailPresenterType  {
    var user: User?
    weak var view: UserViewProtocol?
    let coreDataManager: CoreDataManagerType
    
    required init( view: UserViewProtocol, user: User, coreDataManager: CoreDataManagerType) {
        self.view = view
        self.user = user
        self.coreDataManager = coreDataManager
    }
    
    func updateUser( user: User,
                     avatar: Data?,
                     name: String?,
                     dateOfBirth: String?,
                     gender: String?) {
        
        coreDataManager.updateUser(user, avatar, name, dateOfBirth, gender)
    }
}
