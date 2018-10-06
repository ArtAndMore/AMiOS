//
//  AppCoordinator.swift
//  iVote
//
//  Created by Hasan Sa on 05/10/2018.
//  Copyright © 2018 Hasan Sa. All rights reserved.
//

import Foundation

import UIKit

protocol Coordinator: class {
  func start()
  var mainStoryBoard: UIStoryboard? { get }
}

extension Coordinator {
  var mainStoryBoard: UIStoryboard? {
    return UIStoryboard(name: "Main", bundle: nil)
  }
}

class AppCoordinator: Coordinator {

  var window: UIWindow

  init(window: UIWindow) {
    self.window = window
  }

  func start() {
    if ElectionsService.shared.isAuthenticated {
      showHomeViewController()
    } else {
      showLoginViewController()
    }
  }
}

fileprivate extension AppCoordinator {
  func showLoginViewController() {
    let authenticationCoordinator = AuthenticationCoordinator(window: window)
    authenticationCoordinator.delegate = self
    authenticationCoordinator.start()
  }

  func showCodeValidationViewController() {
    let codeValidationCoordinator = CodeValidationCoordinator(window: window)
    codeValidationCoordinator.delegate = self
    codeValidationCoordinator.start()
  }

  func showHomeViewController() {
    let codeValidationCoordinator = HomeCoordinator(window: window)
    codeValidationCoordinator.delegate = self
    codeValidationCoordinator.start()
  }
}


extension AppCoordinator: AuthenticationCoordinatorDelegate {
  func authenticationCoordinatorDidFinish(authenticationCoordinator: AuthenticationCoordinator) {
    self.showCodeValidationViewController()
  }
}

extension AppCoordinator: CodeValidationCoordinatorDelegate {
  func codeValidationCoordinatorDidFinish(codeValidationCoordinator: CodeValidationCoordinator) {
    self.showHomeViewController()
  }
}

extension AppCoordinator: HomeCoordinatorDelegate {
  func logout(coordinator: HomeCoordinator) {
    self.showLoginViewController()
  }


}
