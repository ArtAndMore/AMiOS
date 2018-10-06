//
//  CodeValidationViewModel.swift
//  iVote
//
//  Created by Hasan Sa on 06/10/2018.
//  Copyright © 2018 Hasan Sa. All rights reserved.
//

import Foundation

protocol CodeValidationViewModelViewDelegate: AnyObject {
  func pinCode() -> String
}

protocol CodeValidationViewModelCoordinatorDelegate: AnyObject {
  func codeValidationViewModelDidEnterCode(viewModel: CodeValidationViewModel)
}


class CodeValidationViewModel {
  var viewDelegate: CodeValidationViewModelViewDelegate?
  var coordinatorDelegate: CodeValidationViewModelCoordinatorDelegate?

  // Name and Password and Phone
  var code: String?

  init() {
    ElectionsService.shared.getCode() { self.code = $0 }
  }

  // Submit
  func submit() {
    // TODO: execute submit code
    #if false
    guard let requestCode = self.code else {
      print("request code failed")
      return
    }
    if requestCode == self.viewDelegate.pinCode() {
      ElectionsService.shared.isAuthenticated = true
      self.coordinatorDelegate?.showHome()
    }
    #else
    self.coordinatorDelegate?.codeValidationViewModelDidEnterCode(viewModel: self)
    #endif
  }
}
