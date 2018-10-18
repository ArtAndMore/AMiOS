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
    showLoadingViewController()
  }
}

private extension AppCoordinator {
  func showLoadingViewController() {
    let loadingCoordinator = LoadingCoordinator(window: window)
    loadingCoordinator.delegate = self
    loadingCoordinator.start()
  }

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

  func showHomeViewController() {
    let homeCoordinator = HomeCoordinator(window: window)
    homeCoordinator.delegate = self
    homeCoordinator.start()
  }
}

extension AppCoordinator: LoadingCoordinatorDelegate {
  func loadingCoordinatorDidFinish(loadingCoordinator: LoadingCoordinator) {
    // self.showCodeValidationViewController()
    if UserAuth.shared.isAuthenticated  {
      showHomeViewController()
    } else {
      showRegionViewController()
    }
  }
}

extension AppCoordinator: RegionCoordinatorDelegate {
  func regionCoordinatorDidFinish(regionCoordinator: RegionCoordinator) {
    self.showLoginViewController()
  }
}

extension AppCoordinator: AuthenticationCoordinatorDelegate {
  func authenticationCoordinatorLogin(authenticationCoordinator: AuthenticationCoordinator) {
    if UserAuth.shared.isAuthenticated {
      self.showHomeViewController()
    }
  }
}

extension AppCoordinator: CodeValidationCoordinatorDelegate {
  func codeValidationCoordinatorDidFinish(codeValidationCoordinator: CodeValidationCoordinator) {
    if UserAuth.shared.isAuthenticated {
      self.showHomeViewController()
    }
  }
}

extension AppCoordinator: HomeCoordinatorDelegate {
  func logout(coordinator: HomeCoordinator) {
    DataController.shared.emptyUsers()
    DataController.shared.emptyNominees()
    self.showRegionViewController()
  }
}
