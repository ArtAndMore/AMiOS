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
    if let user = DataController.shared.authenticatedUser {
      showHomeViewController(forUser: user)
    } else {
      showRegionViewController()
    }
  }
}

fileprivate extension AppCoordinator {
  func showRegionViewController() {
    let regionCoordinator = RegionCoordinator(window: window)
    regionCoordinator.delegate = self
    regionCoordinator.start()
  }

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

  func showHomeViewController(forUser user: User) {
    let homeCoordinator = HomeCoordinator(window: window, user: user)
    homeCoordinator.delegate = self
    homeCoordinator.start()
  }
}

extension AppCoordinator: RegionCoordinatorDelegate {
  func regionCoordinatorDidFinish(regionCoordinator: RegionCoordinator) {
    self.showLoginViewController()
  }
}

extension AppCoordinator: AuthenticationCoordinatorDelegate {
  func authenticationCoordinatorDidFinish(authenticationCoordinator: AuthenticationCoordinator) {
    self.showCodeValidationViewController()
  }
}

extension AppCoordinator: CodeValidationCoordinatorDelegate {
  func codeValidationCoordinatorDidFinish(codeValidationCoordinator: CodeValidationCoordinator) {
    if let user = DataController.shared.authenticatedUser {
      self.showHomeViewController(forUser: user)
    }
  }
}

extension AppCoordinator: HomeCoordinatorDelegate {
  func logout(coordinator: HomeCoordinator) {
    DataController.shared.deleteAllUsers()
    self.showRegionViewController()
  }


}
