//
//  AppDelegate.swift
//  TableViewCoreDataMVP
//
//  Created by 1234 on 26.11.2023.
//

import UIKit
import CoreData

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        window = UIWindow(frame: UIScreen.main.bounds)
        
        let viewController = ViewController()
        let dataManager = CoreDataManager()
        let presenter = Presenter(view: viewController, coreDataManager: dataManager)
        viewController.presenter = presenter
        
        let navigationController = UINavigationController(rootViewController: viewController)
        window?.rootViewController = navigationController
        
        window?.makeKeyAndVisible()
        return true
    }
}
