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
    get {
      return ElectionsService.shared.user
    }
    set {
      ElectionsService.shared.user = user
    }
  }

  var currentBallot: String {
    get {
      return ElectionsService.shared.currentBallot
    }
    set {
      ElectionsService.shared.currentBallot = newValue
    }
  }

  // Errors
  var errorMessage: String?

  // Submit
  func submit() {
    guard self.viewDelegate?.canSubmit() ?? false else {
      return
    }
    ElectionsService.shared.authenticate() { (permission) in
      if permission != nil {
        self.saveUser()
        DispatchQueue.main.async {
          self.coordinatorDelegate?.authenticateViewModelDidLogin(viewModel:self)
        }
      } else {
        self.errorMessage = "authenticate failed"
      }
    }
  }

  private func saveUser() {
    let context = DataController.shared.backgroundContext
    CoreDataUser.addUser(name: user.name, password: user.password, phone: user.phone, path: user.path, intoContext: context)
  }
}

