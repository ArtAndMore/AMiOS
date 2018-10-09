//
//  CoreData+User.swift
//  iVote
//
//  Created by Hasan Sa on 08/10/2018.
//  Copyright © 2018 Hasan Sa. All rights reserved.
//

import Foundation
import CoreData

extension CoreDataUser {

  static func addUser(name: String, password: String, phone: String, path: String, intoContext context: NSManagedObjectContext?) {
    if let context = context {
      let newEntry = CoreDataUser(context: context)
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
