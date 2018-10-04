//
//  Voter.swift
//  Elections
//
//  Created by Hasan Sa on 25/08/2018.
//  Copyright © 2018 Hasan Sa. All rights reserved.
//

import Foundation

struct Voter: Codable {
  let id: String
  let familyName: String
  let name: String
  let fatherName: String
  let ballotId: Int
  let ballotNumber: Int
  var hasVoted: Bool
  
  init(id: String, familyName: String, name: String, fatherName: String, ballotId: Int, ballotNumber: Int, hasVoted: Bool) {
  self.id = id
    self.familyName = familyName
    self.name = name
    self.fatherName = fatherName
    self.ballotId = ballotId
    self.ballotNumber = ballotNumber
    self.hasVoted = hasVoted
  }
}
