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
  weak var viewDelegate: CodeValidationViewModelViewDelegate?
  var coordinatorDelegate: CodeValidationViewModelCoordinatorDelegate?

  // Name and Password and Phone
  var code: String? {
    didSet {
      print(code ?? "")
    }
  }

  private var user: User {
    return ElectionsService.shared.user
  }

  init() {
    ElectionsService.shared.getCode() {(code,_) in self.code = code }
  }

  // Errors
  var errorMessage: Observable<String?> = Observable(nil)

  // Submit
  func submit() {

    guard let requestCode = self.code else {
      self.errorMessage.value =  "request code failed"
      return
    }
    if requestCode == self.viewDelegate?.pinCode() {
      self.saveUser()
      DispatchQueue.main.async {
        self.coordinatorDelegate?.codeValidationViewModelDidEnterCode(viewModel: self)
      }
    } else {
      self.errorMessage.value = "incorrect code"
    }
  }

  private func saveUser() {
    let context = DataController.shared.backgroundContext
    UserEntity.addUser(name: user.name, password: user.password, phone: user.phone, path: user.path, intoContext: context)
  }

}
