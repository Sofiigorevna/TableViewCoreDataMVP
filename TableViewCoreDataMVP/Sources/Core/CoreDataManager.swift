//
//  CoreDataManager.swift
//  TableViewCoreDataMVP
//
//  Created by 1234 on 26.11.2023.
//

import CoreData

protocol CoreDataManagerType {

    func saveUserName(_ name: String)
    func deleteUser(user: User)
    func fetchAllUsers()  -> [User]?
    func updateUser(_ user: User,
                      _ photoImage: String?,
                      _ name: String?,
                      _ dateOfBirth: String?,
                      _ gender: String?)
}

class CoreDataManager: CoreDataManagerType {
    
    // MARK: - Properties

    private let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "User")

    private lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "TableViewCoreDataMVP")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    private lazy var context: NSManagedObjectContext = persistentContainer.viewContext

    // MARK: - Functions

    func saveUserName(_ name: String) {
        guard let entityDescription = NSEntityDescription.entity(forEntityName: "User",
                                                                 in: context) else {return}
        let newUser = User(entity: entityDescription,
                               insertInto: context)
        newUser.name = name
        saveContext()
    }

    func updateUser(_ user: User,
                      _ photoImage: String?,
                      _ name: String?,
                      _ dateOfBirth: String?,
                      _ gender: String?) {

        if let photoImage = photoImage {
            user.photoImage = photoImage
        }
        if let name = name {
            user.name = name
        }
        if let dateOfBirth = dateOfBirth {
            user.dateOfBirth = dateOfBirth
        }
        if let gender = gender {
            user.gender = gender
        }
        saveContext()
    }

    func fetchAllUsers() -> [User]? {
        
        do {
            let persons = try context.fetch(fetchRequest) as? [User]
            return persons
        } catch {
            print(error)
            return nil
        }
    }

    func deleteUser(user: User) {
        context.delete(user)
        saveContext()
    }

    // MARK: - Core Data Saving support

    private func saveContext () {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}
