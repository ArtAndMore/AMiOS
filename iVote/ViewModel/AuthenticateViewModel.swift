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
  var user: User {
      return UserAuth.shared.user
  }

  // Errors
  var errorMessage: Observable<String?> = Observable(nil)

  // Submit
  func submit() {
    guard self.viewDelegate?.canSubmit() ?? false else {
      self.errorMessage.value = "invalid form"
      return
    }
    UserAuth.shared.authenticatedUser { isAuthenticated in
      if isAuthenticated {
        self.saveUser()
        DispatchQueue.main.async {
          self.coordinatorDelegate?.authenticateViewModelDidLogin(viewModel:self)
        }
      } else {
        self.errorMessage.value = "authenticate failed"
      }
    }
  }

  private func saveUser() {
    let context = DataController.shared.backgroundContext
    UserEntity.addUser(name: user.name, password: user.password, phone: user.phone, path: user.path, intoContext: context)
  }
}

