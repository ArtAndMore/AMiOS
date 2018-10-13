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
    return ElectionsService.shared.user.permission.ballots
  }

  var canUpdateVote = false
  // Errors
  var errorMessage: Observable<String?> = Observable(nil)

  func submit() {
    let ballotId = voter.ballotId ?? self.ballotId
    guard let ballotNumber = self.voter.ballotNumber,
      (self.viewDelegate?.canSubmit() ?? false) else {
        self.errorMessage.value = "invalid voter data"
        return
    }
    ElectionsService.shared.updateVoter(withBallotId: ballotId, ballotNumber: ballotNumber) { (error) in
      if error == nil || error == .noNetworkConnection  {
        if error == .noNetworkConnection {
          let context = DataController.shared.viewContext
          VoterEntity.addVoter(ballotId: self.ballotId, ballotNumber: ballotNumber, intoContext: context)
        }
        DispatchQueue.main.async {
          self.viewDelegate?.voteUpdaterViewModel(didUpdateVoter: true)
        }
      }
    }
  }
}
