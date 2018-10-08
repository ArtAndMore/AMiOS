//
//  AuthenticateViewModel.swift
//  iVote
//
//  Created by Hasan Sa on 05/10/2018.
//  Copyright © 2018 Hasan Sa. All rights reserved.
//


import Foundation


protocol AuthenticateViewModelViewDelegate: AnyObject {
  func canSubmit() -> Bool
}

protocol AuthenticateViewModelCoordinatorDelegate: AnyObject {
  func authenticateViewModelDidLogin(viewModel: AuthenticateViewModel)
}

class AuthenticateViewModel {
  weak var viewDelegate: AuthenticateViewModelViewDelegate?
  var coordinatorDelegate: AuthenticateViewModelCoordinatorDelegate?

  // Name and Password and Phone
  var user: User = User()

  // Errors
  var errorMessage: String?

  // Submit
  func submit() {
    guard self.viewDelegate?.canSubmit() ?? false else {
      return
    }
    ElectionsService.shared.authenticate(user: user) { (success) in
      if success {
        DispatchQueue.main.async {
          self.coordinatorDelegate?.authenticateViewModelDidLogin(viewModel:self)
        }
      } else {
        self.errorMessage = "authenticate failed"
      }
    }
  }
}

