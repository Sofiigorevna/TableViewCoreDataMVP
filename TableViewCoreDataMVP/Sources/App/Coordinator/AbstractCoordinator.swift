//
//  AbstractCoordinator.swift
//  TableViewCoreDataMVP
//
//  Created by 1234 on 30.11.2023.
//

import Foundation

protocol AbstractCoordinator {
    func addChildCoordinator(_ coordinator: AbstractCoordinator)
}
