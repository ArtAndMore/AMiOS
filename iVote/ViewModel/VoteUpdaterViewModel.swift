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
  var viewDelegate: VoteUpdaterViewModelDelegate?

  var voter: Voter?

  func submit() {
    // excute update request via Elections service
    guard (self.viewDelegate?.canSubmit() ?? false) else {
      return
    }
    self.viewDelegate?.voteUpdaterViewModel(didUpdateVoter: true)
  }
}
