//
//  NetworkConnectionReachablilityHandler.swift
//  iVote
//
//  Created by Hasan Sa on 16/10/2018.
//  Copyright © 2018 Hasan Sa. All rights reserved.
//

import Foundation
import UIKit

class NetworkConnectionReachablilityHandler: UIResponder {
  static let shared = NetworkConnectionReachablilityHandler()

  func configure() {
    self.observeReachabilityChanges()
  }
}

private extension NetworkConnectionReachablilityHandler {

  func observeReachabilityChanges() {
    NotificationCenter.default.addObserver(self, selector: #selector(whenNetworkConnectionIsUnreachable), name: NSNotification.Name.NetworkConnectionIsUnreachable, object: nil)

    NotificationCenter.default.addObserver(self, selector: #selector(whenNetworkConnectionIsReachable), name: NSNotification.Name.NetworkConnectionIsReachable, object: nil)
  }

  @objc func whenNetworkConnectionIsUnreachable() {
    showAlert(withStatus: .noConnection)
  }

  @objc func whenNetworkConnectionIsReachable() {
    let voters = DataController.shared.fetchVoters()
    if !voters.isEmpty {
      self.updateVoters(voters)
    }
    UserAuth.shared.allowedBallots.forEach { (ballot) in
      let nominees = DataController.shared.fetchNominees(withBallotId: ballot.id)
      if !nominees.isEmpty {
        self.updateNominees(nominees)
      }
    }
  }

  func updateVoters(_ voters: [Voter]) {
    voters.forEach { (voter) in
      let viewModel = VoteUpdaterViewModel()
      viewModel.voter = voter
      viewModel.submit(completion: { (success) in
        if success {
          DataController.shared.emptyVoter(voter)
        }
      })
    }
  }

  func updateNominees(_ nominees: [NomineeEntity]) {
    nominees.filter({ $0.lastUpdatedCount != $0.count }).forEach { (nominee) in
      let delta = nominee.count - nominee.lastUpdatedCount
      let sign = (delta > 0) ? 1 : -1
      let viewModel = NomineeCountingViewModel()
      (0..<abs(delta)).forEach({ _ in
        viewModel.update(nomineeWithId: nominee.id, sign: sign, updateCount: false)
      })
    }
  }
}
