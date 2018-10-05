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
  let lastName: String?
  let firstName: String?
  let middleName: String?
  let ballotId: Int?
  let ballotNumber: Int?
  var hasVoted: Bool = false
}
