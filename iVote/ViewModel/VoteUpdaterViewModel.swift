//
//  VoteUpdaterViewModel.swift
//  iVote
//
//  Created by Hasan Sa on 06/10/2018.
//  Copyright © 2018 Hasan Sa. All rights reserved.
//

import Foundation

protocol VoteUpdaterViewModelDelegate: AnyObject {
  func canSubmit() -> Bool
  func voteUpdaterViewModel(didUpdateVoter success: Bool)
}

class VoteUpdaterViewModel {
  weak var viewDelegate: VoteUpdaterViewModelDelegate?

  var voter: Voter = Voter(id: "")

  var ballotId: String {
    return ElectionsService.shared.currentBallot
  }

  var allowedBallots: [Ballot] {
    return UserAuth.shared.allowedBallots
  }

  var canUpdateVote = false
  // Errors
  var errorMessage: Observable<String?> = Observable(nil)

  private var dispatchWorkItem: DispatchWorkItem?

  func submit(completion: ((Bool) -> Void)? = nil) {
    let ballotId = voter.ballotId ?? self.ballotId
    guard let ballotNumber = self.voter.ballotNumber,
      (self.viewDelegate?.canSubmit() ?? true) else {
        self.errorMessage.value = "invalid voter data"
        completion?(false)
        return
    }
    self.dispatchWorkItem = DispatchWorkItem {
      let context = DataController.shared.backgroundContext
      VoterEntity.addVoter(ballotId: self.ballotId, ballotNumber: ballotNumber, intoContext: context)
    }

    ElectionsService.shared.updateVoter(withBallotId: ballotId, ballotNumber: ballotNumber) { [weak self] (error) in
      if error == nil || error == .noNetworkConnection  {
        if error == .noNetworkConnection {
          if let workItem = self?.dispatchWorkItem {
            DispatchQueue.global().async(execute: workItem)
          }
        }
        DispatchQueue.main.async {
          self?.viewDelegate?.voteUpdaterViewModel(didUpdateVoter: true)
        }
        completion?(true)
      } else {
        completion?(false)
      }
    }
  }
}
