//
//  DependencyFactory.swift
//  TableViewCoreDataMVP
//
//  Created by 1234 on 01.12.2023.
//

import UIKit

protocol Factory {
    func makeInitialViewController(coordinator: ProjectCoordinator) -> ViewController
    func makeDetaillViewController(coordinator: ProjectCoordinator, data: User) -> DetailViewController
}

class DependencyFactory: Factory {
    
    var coreDataManager: CoreDataManagerType = CoreDataManager()

    func makeDetaillViewController(coordinator: ProjectCoordinator, data: User) -> DetailViewController {
        let viewController = DetailViewController()
        let presenter = DetailPresenter(view: viewController, user: data, coreDataManager: coreDataManager)
        viewController.set(presenter: presenter)
        return viewController
    }
    
    func makeInitialViewController(coordinator: ProjectCoordinator) -> ViewController {
        let viewController = ViewController()
        let presenter = MainPresenter(view: viewController, coordinator: coordinator, coreDataManager: coreDataManager)
        viewController.set(presenter: presenter)
        return viewController
    }
    
    func makeInitialCoordinator() -> ProjectCoordinator {
        let coordinator = ProjectCoordinator(factory: self)
        return coordinator
    }
}
