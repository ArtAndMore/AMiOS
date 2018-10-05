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
}

class AppCoordinator: Coordinator {

  var window: UIWindow

  fileprivate var mainStoryBoard: UIStoryboard? {
    return UIStoryboard(name: "Main", bundle: nil)
  }

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
    if let navigationController = mainStoryBoard?.instantiateInitialViewController() as? UINavigationController,
      let loginViewCintroller = navigationController.topViewController as? LoginViewController {
      loginViewCintroller.coordinatorDelegate = self
      window.rootViewController = navigationController
    }
  }

  func showCodeValidationViewController() {
    if let vc = mainStoryBoard?.instantiateViewController(withIdentifier: "CodeValidationViewController") as? CodeValidationViewController,
      let navigationController = window.rootViewController as? UINavigationController {
      vc.coordinatorDelegate = self
      navigationController.pushViewController(vc, animated: true)
    }
  }

  func showHomeViewController() {
    if let navigationController = mainStoryBoard?.instantiateViewController(withIdentifier: "HomeViewController") as? UINavigationController,
      let homeViewCintroller = navigationController.topViewController as? HomeViewController {
      homeViewCintroller.coordinatorDelegate = self
      window.rootViewController = navigationController
    }
  }
}


// MARK: - LoginNavigationControllerDelegate
extension AppCoordinator: NavigationViewControllerCoordinatorDelegate {
  func showCode() {
    self.showCodeValidationViewController()
  }
}

// MARK: - CodeValidationViewControllerCoordinatorDelegate
extension AppCoordinator: CodeValidationViewControllerCoordinatorDelegate {
  func showHome() {
    self.showHomeViewController()
  }
}

// MARK: - HomeViewControllerCoordinatorDelegate
extension AppCoordinator: HomeViewControllerCoordinatorDelegate {

}
