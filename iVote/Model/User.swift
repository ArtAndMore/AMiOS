//
//  User.swift
//  iVote
//
//  Created by Hasan Sa on 04/10/2018.
//  Copyright © 2018 Hasan Sa. All rights reserved.
//

import Foundation

class Permission {
  var canReadStatistics = true
  var canQuery = true
  var canUpdateVotes = true
  var canUpdateNomineeCount = true
  var canReadBallots = true
  var canReportIssue = true
  var ballots: [Ballot] = []
}

class User {
  var name: String = ""
  var password: String = ""
  var phone: String = ""
  var path: String = ""
  var permission: Permission?
}

