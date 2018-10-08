//
//  Status.swift
//  iVote
//
//  Created by Hasan Sa on 04/10/2018.
//  Copyright © 2018 Hasan Sa. All rights reserved.
//

import Foundation

class StatusBase {
  var total: String?
  var isVoted: String?
  var notVoted: String?
  var votingPercentage: String?
}

class BallotStatus: StatusBase {}

class VotersStatus: StatusBase {}

struct Status {
  var ballot: BallotStatus
  var voters: VotersStatus
}
