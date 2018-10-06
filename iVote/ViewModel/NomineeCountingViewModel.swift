//
//  NomineeCountingViewModel.swift
//  iVote
//
//  Created by Hasan Sa on 06/10/2018.
//  Copyright © 2018 Hasan Sa. All rights reserved.
//

import Foundation

protocol NomineeCountingViewModelDelegate: AnyObject {
  func nomineesCountingDidLoaded()
  func nommineeCountingDidUpdateStatus()
}

class NomineeCountingViewModel {
  var viewDelegate: NomineeCountingViewModelDelegate?

  var nominees: [Nominee] = []

  init() {
    // TODO: execute get all nominee
    let nominee = Nominee()
    nominee.name = "Yasir Tabash"
    nominees = [nominee]
    self.viewDelegate?.nomineesCountingDidLoaded()
  }

  func update(nomineeAtIndex index: Int, status: Int) {
    guard index < nominees.count else {
      return
    }
    let nominee = nominees[index]
    nominee.status = status
    // excute increment request via Elections service
    self.viewDelegate?.nommineeCountingDidUpdateStatus()
  }
}
