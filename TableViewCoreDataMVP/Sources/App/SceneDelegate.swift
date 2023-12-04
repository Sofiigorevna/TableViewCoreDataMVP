//
//  SceneDelegate.swift
//  TableViewCoreDataMVP
//
//  Created by 1234 on 29.11.2023.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    let dataManager = CoreDataManager()
    let detailViewController = DetailViewController()

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: windowScene)
        
        let roootNC = UINavigationController()
        let container = DependencyFactory()
        
        let coordinator = container.makeInitialCoordinator()
        
        coordinator.start(roootNC)

        window?.rootViewController = roootNC
        window?.makeKeyAndVisible()
    }
}
