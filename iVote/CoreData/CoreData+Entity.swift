//
//  CoreData+Entity.swift
//  iVote
//
//  Created by Hasan Sa on 12/10/2018.
//  Copyright © 2018 Hasan Sa. All rights reserved.
//

import Foundation

import CoreData

extension UserEntity {

  static func addUser(name: String, password: String, phone: String, path: String, intoContext context: NSManagedObjectContext?) {
    if let context = context {
      let newEntry = UserEntity(context: context)
      newEntry.name = name
      newEntry.password = password
      newEntry.phone = phone
      newEntry.path = path
      do {
        try context.save()

      } catch {

        print("Failed saving")
      }
    }
  }
}

extension VoterEntity {

  static func addVoter(ballotId: String, ballotNumber: String, intoContext context: NSManagedObjectContext?) {
    if let context = context {
      let newEntry = VoterEntity(context: context)
      newEntry.ballotId = ballotId
      newEntry.ballotNumber = ballotNumber
      do {
        try context.save()

      } catch {

        print("Failed saving")
      }
    }
  }
}


extension NomineeEntity {
  static func addNominee(id: String, status: Int, intoContext context: NSManagedObjectContext?) {
    if let context = context {
      let newEntry = NomineeEntity(context: context)
      newEntry.id = id
      newEntry.status = Int64(status)
      do {
        try context.save()

      } catch {

        print("Failed saving")
      }
    }
  }
}
