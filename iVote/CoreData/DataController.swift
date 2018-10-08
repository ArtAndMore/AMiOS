//
//  DataController.swift
//  iVote
//
//  Created by Hasan Sa on 08/10/2018.
//  Copyright © 2018 Hasan Sa. All rights reserved.
//

import Foundation
import CoreData

class DataController {
  static let shared = DataController()

  var authenticatedUserName: String? {
    return self.fetchUsers(intoContext: viewContext)
  }

  static func configure() {
    _ = self.shared.persistentContainer
    self.shared.configureContexts()
  }

  var viewContext: NSManagedObjectContext {
    return self.persistentContainer.viewContext
  }

  var backgroundContext: NSManagedObjectContext!

  lazy var persistentContainer: NSPersistentContainer = {
    /*
     The persistent container for the application. This implementation
     creates and returns a container, having loaded the store for the
     application to it. This property is optional since there are legitimate
     error conditions that could cause the creation of the store to fail.
     */
    let container = NSPersistentContainer(name: "iVoteModel")
    container.loadPersistentStores(completionHandler: { (storeDescription, error) in
      if let error = error as NSError? {
        // Replace this implementation with code to handle the error appropriately.
        // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.

        /*
         Typical reasons for an error here include:
         * The parent directory does not exist, cannot be created, or disallows writing.
         * The persistent store is not accessible, due to permissions or data protection when the device is locked.
         * The device is out of space.
         * The store could not be migrated to the current model version.
         Check the error message to determine what the actual problem was.
         */
        fatalError("Unresolved error \(error), \(error.userInfo)")
      }
    })
    return container
  }()

  func configureContexts() {
    self.backgroundContext = self.persistentContainer.newBackgroundContext()
    viewContext.automaticallyMergesChangesFromParent = true
    backgroundContext?.automaticallyMergesChangesFromParent = true

    backgroundContext.mergePolicy = NSMergePolicy.mergeByPropertyObjectTrump
    viewContext.mergePolicy = NSMergePolicy.mergeByPropertyStoreTrump
  }


   func fetchUsers(intoContext context: NSManagedObjectContext?) -> String? {
    let request = NSFetchRequest<NSFetchRequestResult>(entityName: "CoreDataUser")
    //request.predicate = NSPredicate(format: "age = %@", "12")
    request.returnsObjectsAsFaults = false

    do {
      let result = try context?.fetch(request) as? [CoreDataUser]
        return result?.first?.name

    } catch {

      print("Failed")
    }
    return nil
  }

  func deleteAllUsers() {
    let context = viewContext

    let request = NSFetchRequest<NSFetchRequestResult>(entityName: "CoreDataUser")
    //request.predicate = NSPredicate(format: "age = %@", "12")
    request.returnsObjectsAsFaults = false

    do {
      let result = try context.fetch(request)
      for data in result as! [NSManagedObject] {
        context.delete(data)
      }

      try? context.save()

    } catch {

      print("Failed")
    }
  }
}
