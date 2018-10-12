//
//  ReportCenterViewModel.swift
//  iVote
//
//  Created by Hasan Sa on 06/10/2018.
//  Copyright © 2018 Hasan Sa. All rights reserved.
//

import Foundation

protocol ReportCenterViewModelDlelegate: AnyObject {
  func reportCenterViewModel(didUpdateStatus success:Bool)
  func reportCenterViewModel(didSentMessage success:Bool)
}

class ReportCenterViewModel {
  weak var viewDelegate: ReportCenterViewModelDlelegate?

  // Errors
  var errorMessage: Observable<String?> = Observable(nil)

  func sendReport(byType type: ReportType, status: Int) {
    ElectionsService.shared.updateReport(byType: type, status: status) { (error) in
      DispatchQueue.main.async {
        self.viewDelegate?.reportCenterViewModel(didUpdateStatus: (error != nil))
      }
    }
  }

  func sendReport(message: String) {
    guard !message.isEmpty else {
      self.errorMessage.value = "empty message" 
      return
    }
    ElectionsService.shared.sendReportMessage(message) { error in
      DispatchQueue.main.async {
        self.viewDelegate?.reportCenterViewModel(didSentMessage: (error != nil))
      }
    }
  }
}
