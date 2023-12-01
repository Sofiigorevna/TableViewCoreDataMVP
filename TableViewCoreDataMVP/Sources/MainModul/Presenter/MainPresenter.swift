//
//  MainPresenter.swift
//  TableViewCoreDataMVP
//
//  Created by 1234 on 30.11.2023.
//

import Foundation
 
protocol MainPresenterType {
    var users: [User] {get}
    func fetchAllUsers()
    func saveUserName(name: String)
    func deleteUser(indexPath: IndexPath)
}

class MainPresenter: MainPresenterType {
    
    let coreDataManager: CoreDataManagerType
    var users = [User]()
    weak private var view: ViewController?
    private var coordinator: ProjectCoordinator?
    
    init(view: ViewController, coordinator: ProjectCoordinator, coreDataManager: CoreDataManagerType) {
        self.coreDataManager = coreDataManager
        self.view = view
        self.coordinator = coordinator
    }
    
    func showDetail(data: User) {
        coordinator?.moveToDetail(withData: data)
    }
    
    func fetchAllUsers() {
        users =  coreDataManager.fetchAllUsers() ?? []
    }

    func saveUserName(name: String) {
        coreDataManager.saveUserName(name)
    }

    func deleteUser(indexPath: IndexPath) {
        coreDataManager.deleteUser(user: users[indexPath.row])
    }

}

