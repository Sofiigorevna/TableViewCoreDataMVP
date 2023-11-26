//
//  Presenter.swift
//  TableViewCoreDataMVP
//
//  Created by 1234 on 26.11.2023.
//

import UIKit

protocol PresenterType {
    
    var users: [User] { get set }
    func fetchAllUsers()
    func saveUserName(name: String)
    func deleteUser(indexPath: IndexPath)
    init(view: UserViewProtocol,
         coreDataManager: CoreDataManagerType)
}

class Presenter: PresenterType {
    
    weak var view: UserViewProtocol?
    var users = [User]()
    var coreDataManager: CoreDataManagerType
    
    
    required init(view: UserViewProtocol, coreDataManager: CoreDataManagerType) {
        self.coreDataManager = coreDataManager
        self.view = view
    }
    
    func fetchAllUsers() {
        
        users =  coreDataManager.fetchAllUsers() ?? []
        self.view?.showUsers(users: users)
        
    }
    
    func saveUserName(name: String) {
        
        coreDataManager.saveUserName(name)
    }
    
    func updateUser(user: User,
                    photoImage: String,
                    name: String,
                    dateOfBirth: String,
                    gender: String) {
        
        coreDataManager.updateUser(user, photoImage, name, dateOfBirth, gender)
    }
    
    func deleteUser(indexPath: IndexPath) {
        
        coreDataManager.deleteUser(user: users[indexPath.row])
    }
}

