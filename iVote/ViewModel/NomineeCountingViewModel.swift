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
  var currentBallot: String! {
    didSet {
      self.nominees = DataController.shared.fetchNominees(withBallotId: currentBallot)
    }
  }

  var nominees: [NomineeEntity] = []

  // Errors
  var errorMessage: Observable<String?> = Observable(nil)

  private var dispatchWorkItem: DispatchWorkItem?

  func update(nomineeWithId id: String?, sign: Int, updateCount: Bool = true) {
    guard let nominee = nominees.filter({ $0.id == id}).first else {
      return
    }

    self.dispatchWorkItem = DispatchWorkItem {
      try? DataController.shared.backgroundContext.save()
    }
    nominee.sign = Int16(sign)
    nominee.ballotId = currentBallot
    // if updateCount
    nominee.count += updateCount ? Int64(sign) : 0

    ElectionsService.shared.updateNominee(nominee) { [weak self] (error) in
      if error == nil || error == .noNetworkConnection  {
        if error == nil {
          nominee.lastUpdatedCount = nominee.count
        }
        if let workItem = self?.dispatchWorkItem {
          DispatchQueue.global().async(execute: workItem)
        }
        DispatchQueue.main.async {
          self?.viewDelegate?.nommineeCountingViewModel(didUpdateStatus: true)
        }
      }
    }
  }
}
