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

  var currentBallot: String!

  var nominees: [Nominee] = [] {
    didSet {
      DispatchQueue.main.async {
        self.viewDelegate?.nomineesCountingViewModelDidLoaded()
      }
    }
  }

  // Errors
  var errorMessage: Observable<String?> = Observable(nil)

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
    ElectionsService.shared.updateNominee(nominee) { (error) in
      if error == nil || error == .noNetworkConnection  {
        if error == .noNetworkConnection {
          let context = DataController.shared.viewContext
          NomineeEntity.addNominee(id: nominee.id, status: nominee.status, intoContext: context)
        }
        DispatchQueue.main.async {
          self.viewDelegate?.nommineeCountingViewModel(didUpdateStatus: true)
        }
      }
    }
  }
}
