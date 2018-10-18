//
//  UserAuth.swift
//  iVote
//
//  Created by Hasan Sa on 18/10/2018.
//  Copyright © 2018 Hasan Sa. All rights reserved.
//

import Foundation

class UserAuth {
  static let shared = UserAuth()

  var user: User = User()

  private(set) var isAuthenticated: Bool = false

  var ballots: Observable<[Ballot]> = Observable([])

  var allowedBallots: [Ballot] {
    return user.permission?.ballots ?? []
  }

  func authenticatedUser(completion: @escaping ((Bool) -> Void)) {
    self.isAuthenticated = false

    if let user = DataController.shared.authenticatedUser {
      self.user = user
    }

    if self.user.name.isEmpty {
      completion(false)
      return
    }
    // load user permissions
    ElectionsService.shared.authenticate { (permission, error) in

      guard let permission = permission, error == nil else {
        completion(false)
        return
      }
      self.isAuthenticated = true
      self.user.permission = permission
      self.loadUserData()
      completion(true)
    }
  }

  private func loadUserData() {
    guard let permission = self.user.permission else {
      return
    }
    // getAllBallots
    ElectionsService.shared.getAllBallots { (ballots, error) in
      guard error == nil  else {
        return
      }
      self.ballots.value = permission.canReadBallots ? ballots.sorted(by: { Int($0.number)! < Int($1.number)! }) : []

      // getAllNominee
      guard permission.canUpdateNomineeCount  else {
        return
      }
      ElectionsService.shared.getAllNominee { (nominees, error) in
        guard error == nil  else {
          return
        }
        // store to local DB
        for ballot in ballots {
          let currentNominees = DataController.shared.fetchNominees(withBallotId: ballot.id)
          guard currentNominees.filter({ $0.id == nominees.first?.id }).first == nil else {
            continue
          }

          let context = DataController.shared.backgroundContext
          // SAVE TO Core Data if not exist in DB
          nominees.forEach {
            NomineeEntity.add(nominee: $0, ballotId: ballot.id, intoContext: context)
          }
        }
      }
    }
  }

}
