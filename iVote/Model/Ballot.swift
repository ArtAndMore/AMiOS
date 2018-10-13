//
//  Ballot.swift
//  iVote
//
//  Created by Hasan Sa on 04/10/2018.
//  Copyright © 2018 Hasan Sa. All rights reserved.
//

import Foundation

class Ballot {
  let id: String
  let number: String
  let name: String
  var total: String
  var isVoted: String
  var notVoted: String
  var address: String?

  var reports: [ReportType: Bool] = [.stabilization: false,
                                     .spectator: false,
                                     .notes: false,
                                     .disturbance: false]

  init(id: String, number: String, name: String, total: String, isVoted: String, notVoted: String) {
   self.id = id
   self.number = number
   self.name = name
   self.total = total
   self.isVoted = isVoted
   self.notVoted = notVoted
  }
}
