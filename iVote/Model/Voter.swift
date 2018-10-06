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
  var phoneNumber: String?
  var ballotId: Int?
  var ballotNumber: Int?
  var hasVoted: Bool = false

  init(id: String) {
    self.id = id
  }
}
