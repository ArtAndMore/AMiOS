//
//  AuthenticationCoordinator.swift
//  iVote
//
//  Created by Hasan Sa on 06/10/2018.
//  Copyright © 2018 Hasan Sa. All rights reserved.
//

import Foundation
import UIKit

protocol AuthenticationCoordinatorDelegate: AnyObject {
  func authenticationCoordinatorDidFinish(authenticationCoordinator: AuthenticationCoordinator)
}

class AuthenticationCoordinator: Coordinator {
  weak var delegate: AuthenticationCoordinatorDelegate?
  let window: UIWindow

  init(window: UIWindow) {
    self.window = window
  }

  func start() {
    if let navigationController = mainStoryBoard?.instantiateViewController(withIdentifier: "LoginNavigationViewController") as? UINavigationController,
      let loginViewCintroller = navigationController.topViewController as? LoginViewController {
      let viewModel = AuthenticateViewModel()
      viewModel.coordinatorDelegate = self
      loginViewCintroller.viewModel = viewModel
      window.rootViewController = navigationController
    }
  }
}

extension AuthenticationCoordinator: AuthenticateViewModelCoordinatorDelegate {
  func authenticateViewModelDidLogin(viewModel: AuthenticateViewModel) {
    delegate?.authenticationCoordinatorDidFinish(authenticationCoordinator: self)
  }
}
