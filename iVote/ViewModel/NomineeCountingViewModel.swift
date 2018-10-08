//
//  NomineeCountingViewModel.swift
//  iVote
//
//  Created by Hasan Sa on 06/10/2018.
//  Copyright © 2018 Hasan Sa. All rights reserved.
//

import Foundation

protocol NomineeCountingViewModelDelegate: AnyObject {
  func nomineesCountingViewModelDidLoaded()
  func nommineeCountingViewModel(didUpdateStatus success: Bool)
}

class NomineeCountingViewModel {
  weak var viewDelegate: NomineeCountingViewModelDelegate?

  var nominees: [Nominee] = [] {
    didSet {
      DispatchQueue.main.async {
        self.viewDelegate?.nomineesCountingViewModelDidLoaded()
      }
    }
  }

  init() {
    guard self.nominees.isEmpty else {
      return
    }
  }

  func update(nomineeAtIndex index: Int, status: Int) {
    guard index < nominees.count else {
      return
    }
    let nominee = nominees[index]
    nominee.status = status
    // TODO: Fetch Ballot from local DB
    let currentBallot = "1"
    ElectionsService.shared.updateNominee(nominee, inBallotId: currentBallot) { (success) in
      DispatchQueue.main.async {
        self.viewDelegate?.nommineeCountingViewModel(didUpdateStatus: success)
      }
      // TODO: save status for nominee to local DB
    }
  }
}
