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
  var ballotId: String?
  var ballotNumber: String?

  var canUpdateVote = false
  // Errors
  var errorMessage: Observable<String?> = Observable(nil)

  func submit() {
    guard let ballotId = self.ballotId ?? self.voter?.ballotId,
      let ballotNumber = self.ballotNumber ?? self.voter?.ballotNumber,
      (self.viewDelegate?.canSubmit() ?? false) else {
        self.errorMessage.value = "invalid voter data"
        return
    }
    ElectionsService.shared.updateVoter(withBallotId: ballotId, ballotNumber: ballotNumber) { (success) in
      if success {
        DispatchQueue.main.async {
          self.viewDelegate?.voteUpdaterViewModel(didUpdateVoter: true)
        }
      } else {
        self.errorMessage.value = "could not update voter"
        self.viewDelegate?.voteUpdaterViewModel(didUpdateVoter: false)
      }
    }
  }
}
