//
//  BallotViewModel.swift
//  iVote
//
//  Created by Hasan Sa on 06/10/2018.
//  Copyright © 2018 Hasan Sa. All rights reserved.
//

import Foundation

class BallotViewModel {
  var canReadBallots: Bool {
    return UserAuth.shared.user.permission?.canReadBallots ?? false
  }

  var ballots: Observable<[Ballot]> = Observable([])

  init() {
    UserAuth.shared.ballots.observe {
      self.ballots.value = $0
    }
  }
}
