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

  var voter: Voter?

  var ballotId: String {
    return ElectionsService.shared.currentBallot
  }
  var ballotNumber: String?

  var canUpdateVote = false
  // Errors
  var errorMessage: Observable<String?> = Observable(nil)

  func submit() {
    guard let ballotNumber = self.ballotNumber ?? self.voter?.ballotNumber,
      (self.viewDelegate?.canSubmit() ?? false) else {
        self.errorMessage.value = "invalid voter data"
        return
    }
    ElectionsService.shared.updateVoter(withBallotId: ballotId, ballotNumber: ballotNumber) { (error) in
      if let err = error {
        if err == .noNetworkConnection {
          let context = DataController.shared.viewContext
          VoterEntity.addVoter(ballotId: self.ballotId, ballotNumber: ballotNumber, intoContext: context)
        }
      } else {
        DispatchQueue.main.async {
          self.viewDelegate?.voteUpdaterViewModel(didUpdateVoter: true)
        }
      }
    }
  }
}
