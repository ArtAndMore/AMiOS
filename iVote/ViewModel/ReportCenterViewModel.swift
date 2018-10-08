//
//  ReportCenterViewModel.swift
//  iVote
//
//  Created by Hasan Sa on 06/10/2018.
//  Copyright © 2018 Hasan Sa. All rights reserved.
//

import Foundation

protocol ReportCenterViewModelDlelegate: AnyObject {
  func reportCenterViewModel(didSentMessage success:Bool)
}

class ReportCenterViewModel {
  weak var viewDelegate: ReportCenterViewModelDlelegate?

  func sendReport(byType type: ReportType, status: Int) {
    // TODO: fetch current ballot from local DB
    let currentBallotId = "1"
    ElectionsService.shared.updateReport(byType: type, status: status, inBallotId: currentBallotId) { (_) in

    }
  }

  func sendReport(message: String) {
    let currentBallotId = "1"
    ElectionsService.shared.sendReportMessage(message, inBallotId: currentBallotId) { success in
      DispatchQueue.main.async {
        self.viewDelegate?.reportCenterViewModel(didSentMessage: success)
      }
    }
  }
}
