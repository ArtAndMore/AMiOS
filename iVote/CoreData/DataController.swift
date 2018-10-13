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

  var authenticatedUser: User? {
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

  /**
   The persistent container for the application. This implementation
   creates and returns a container, having loaded the store for the
   application to it. This property is optional since there are legitimate
   error conditions that could cause the creation of the store to fail.
  */
  lazy var persistentContainer: NSPersistentContainer = {
    let container = NSPersistentContainer(name: "iVoteModel")
    container.loadPersistentStores(completionHandler: { (storeDescription, error) in
      if let error = error as NSError? {
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

  // MARK: - Voters
  func fetchVoters() -> [Voter] {
    let request = NSFetchRequest<NSFetchRequestResult>(entityName: "VoterEntity")
    request.returnsObjectsAsFaults = false
    if let result = try? self.backgroundContext?.fetch(request) as? [VoterEntity] {
      return result?.compactMap({
        let voter = Voter(id: "")
        voter.ballotId = $0.ballotId
        voter.ballotNumber = $0.ballotNumber
        return voter
      }) ?? []
    }
    return []
  }

  func emptyVoter(_ voter: Voter) {
    let context = backgroundContext

    let request = NSFetchRequest<NSFetchRequestResult>(entityName: "VoterEntity")
    request.returnsObjectsAsFaults = false

    do {
      if let result = try context?.fetch(request) as? [VoterEntity] {
        if let toDelete = result.filter({ $0.ballotId == voter.ballotId && $0.ballotNumber == voter.ballotNumber }).first {
          context?.delete(toDelete)
        }
      }
      try? context?.save()
    } catch {
      print("Failed")
    }
  }

  // MARK: - Nominees

  func fetchNominees() -> [Nominee] {
    let request = NSFetchRequest<NSFetchRequestResult>(entityName: "NomineeEntity")
    request.returnsObjectsAsFaults = false
    if let result = try? self.backgroundContext?.fetch(request) as? [NomineeEntity] {
      return result?.compactMap({
        let nominee = Nominee()
        if let id = $0.id {
          nominee.id = id
          nominee.status = Int($0.status)
          return nominee
        }
        return nil
      }) ?? []
    }
    return []
  }

  func emptyNominee(_ nominee: Nominee) {
    let context = backgroundContext

    let request = NSFetchRequest<NSFetchRequestResult>(entityName: "NomineeEntity")
    request.returnsObjectsAsFaults = false

    do {
      if let result = try context?.fetch(request) as? [NomineeEntity] {
        if let toDelete = result.filter({ $0.id == nominee.id }).first {
          context?.delete(toDelete)
        }
      }
      try? context?.save()
    } catch {
      print("Failed")
    }
  }

  // MARK: - Users

  func fetchUsers(intoContext context: NSManagedObjectContext?) -> User? {
    let request = NSFetchRequest<NSFetchRequestResult>(entityName: "UserEntity")
    request.returnsObjectsAsFaults = false
    if let result = try? context?.fetch(request) as? [UserEntity] {
      if let first = result?.last, let name = first.name, let password = first.password, let phone = first.phone, let path = first.path {
        let user = User()
        user.name = name
        user.password = password
        user.phone = phone
        user.path = path
        return user
      }
    }
    return nil
  }

  func emptyUsers() {
    self.emptyEntities(name: "UserEntity")
  }

  private func emptyEntities(name entityName: String) {
    let context = viewContext

    let request = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
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
