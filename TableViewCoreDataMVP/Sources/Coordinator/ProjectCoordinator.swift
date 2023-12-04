//
//  ProjectCoordinator.swift
//  TableViewCoreDataMVP
//
//  Created by 1234 on 01.12.2023.
//

import UIKit

protocol AbstractCoordinator {
    func addChildCoordinator(_ coordinator: AbstractCoordinator)
}

protocol RootCoordinator: AnyObject {
    func start(_ navigationController: UINavigationController)
}

class ProjectCoordinator: AbstractCoordinator, RootCoordinator {
   
    
    private var childCoordinators: [AbstractCoordinator] = []
    
    weak var navigationController: UINavigationController?
    private var factory: Factory
    
    init(factory: Factory){
        self.factory = factory
    }
    
    func addChildCoordinator(_ coordinator: AbstractCoordinator) {
        childCoordinators.append(coordinator)
    }
    
    func start(_ navController: UINavigationController) {
        let vc = factory.makeInitialViewController(coordinator: self)
        self.navigationController = navController
        navController.pushViewController(vc, animated: true)
    }
    
    func moveToDetail(withData data: User){
        let vc = factory.makeDetaillViewController(coordinator: self, data: data)
        navigationController?.pushViewController(vc, animated: true)
    }
}
