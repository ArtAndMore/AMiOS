//
//  BallotViewModel.swift
//  iVote
//
//  Created by Hasan Sa on 06/10/2018.
//  Copyright © 2018 Hasan Sa. All rights reserved.
//

import Foundation

protocol BallotViewModelDelegate: AnyObject {
  func ballotViewModelDidLoadBallots()
}

class BallotViewModel {
  weak var viewDelegate: BallotViewModelDelegate?

  var canReadBallots: Bool = false {
    didSet {
      self.getAllBallots()
    }
  }

  var ballots: [Ballot] = [] {
    didSet {
      DispatchQueue.main.async {
        self.viewDelegate?.ballotViewModelDidLoadBallots()
      }
    }
  }

  private func getAllBallots() {
    guard self.canReadBallots, ballots.isEmpty else {
      return
    }
    ElectionsService.shared.getAllBallots { (ballots, error) in
      if error == nil {
        self.ballots = ballots.sorted(by: { Int($0.number)! < Int($1.number)! })
      }
    }
  }
}
