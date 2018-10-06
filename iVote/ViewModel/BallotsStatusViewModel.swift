//
//  BallotsStatusViewModel.swift
//  iVote
//
//  Created by Hasan Sa on 06/10/2018.
//  Copyright © 2018 Hasan Sa. All rights reserved.
//

import Foundation

class BallotsStatusViewModel {
  var viewDelegate: NomineeCountingViewModelDelegate?
  var ballotsStatus: [Status] = []


  init() {
    // TODO: execute get ballots status call from ElectionService
    ballotsStatus = [Status(), Status(), Status()]
  }


}
