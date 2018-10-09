//
//  RegionCoordinator.swift
//  iVote
//
//  Created by Hasan Sa on 09/10/2018.
//  Copyright © 2018 Hasan Sa. All rights reserved.
//

import Foundation

import UIKit

protocol RegionCoordinatorDelegate: AnyObject {
  func regionCoordinatorDidFinish(regionCoordinator: RegionCoordinator)
}

class RegionCoordinator: Coordinator {
  weak var delegate: RegionCoordinatorDelegate?
  let window: UIWindow

  init(window: UIWindow) {
    self.window = window
  }

  func start() {
    if let navigationController = mainStoryBoard?.instantiateViewController(withIdentifier: "RegionNavigationViewController") as? UINavigationController,
      let regionViewCintroller = navigationController.topViewController as? RegionViewController {
      let viewModel = RegionViewModel()
      viewModel.coordinatorDelegate = self
      regionViewCintroller.viewModel = viewModel
      window.rootViewController = navigationController
    }
  }
}

extension RegionCoordinator: RegionViewModelCoordinatorDelegate {
  func regionViewModelCoordinatorDidFinish(viewModel: RegionViewModel) {
    self.delegate?.regionCoordinatorDidFinish(regionCoordinator: self)
  }
}
