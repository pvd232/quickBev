//
//  CoreDataManger.swift
//  Drinkz
//
//  Created by Peter Vail Driscoll II on 12/23/20.
//  Copyright © 2020 Peter Vail Driscoll II. All rights reserved.
//

import CoreData
import UIKit

class CoreDataManager {
    static let sharedManager = CoreDataManager()

    private init() {} // Prevent clients from creating another instance.

    private lazy var storeContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "QuickBev")
        container.loadPersistentStores { _, error in
            if let error = error as NSError? {
                print("Unresolved error \(error), \(error.userInfo)")
            }
        }
        return container
    }()

    lazy var managedContext: NSManagedObjectContext = {
        self.storeContainer.viewContext.mergePolicy = NSMergePolicy(merge: NSMergePolicyType.mergeByPropertyObjectTrumpMergePolicyType)
        return self.storeContainer.viewContext
    }()

    func saveContext() {
        if managedContext.hasChanges {
            do {
                try managedContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                Thread.callStackSymbols.forEach { print($0) }
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        } else {
            print("no changes to context")
        }
    }

    func deleteEntity(entity: NSManagedObject) {
        managedContext.delete(entity)
    }

    func deleteEntities(entityName: String) {
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: entityName)
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)

        do {
            try managedContext.execute(deleteRequest)
        } catch let error as NSError {
            NSLog("Unable to fetch \(error), \(error.userInfo)")
        }
    }

    func fetchEntities(entityName: String) -> [Any]? {
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: entityName)
        var fetchedResults: [Any]?
        do {
            fetchedResults = try managedContext.fetch(fetchRequest)
        } catch let error as NSError {
            NSLog("Unable to fetch \(error), \(error.userInfo)")
        }
        return fetchedResults
    }
}
