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
  var viewDelegate: AuthenticateViewModelViewDelegate?
  var coordinatorDelegate: AuthenticateViewModelCoordinatorDelegate?

  // Name and Password and Phone
  var user: User = User()

  // Submit
  func submit() {
    // TODO: execute login request
    #if false
    guard self.viewModel.viewDelegate?.canSubmit() else {
      return
    }
    ElectionsService.shared.authenticate(user: user) { (success) in
      if success {
        DispatchQueue.main.async {
          self.coordinatorDelegate?.authenticateViewModelDidLogin(viewModel:self)
        }
      } else {
        print("authenticate failed")
      }
    }
    #else
    self.coordinatorDelegate?.authenticateViewModelDidLogin(viewModel: self)
    #endif
  }
  // Errors
  var errorMessage: String?
}

