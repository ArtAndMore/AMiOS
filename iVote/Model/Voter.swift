//
//  Voter.swift
//  Elections
//
//  Created by Hasan Sa on 25/08/2018.
//  Copyright © 2018 Hasan Sa. All rights reserved.
//

import Foundation

class Voter: Codable {
  let id: String
  var lastName: String?
  var firstName: String?
  var fatherName: String?
  var motherName: String?
  var grandFatherName: String?
  var address: String?
  var phoneNumber: String?
  var ballotId: String?
  var ballotNumber: String?
  var hasVoted: String?

  init(id: String) {
    self.id = id
  }
}
