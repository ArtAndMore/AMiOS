//
//  LoadingCoordinator.swift
//  iVote
//
//  Created by Hasan Sa on 18/10/2018.
//  Copyright © 2018 Hasan Sa. All rights reserved.
//

import Foundation
import UIKit

protocol LoadingCoordinatorDelegate: AnyObject {
  func loadingCoordinatorDidFinish(loadingCoordinator: LoadingCoordinator)
}

class LoadingCoordinator: Coordinator {
  weak var delegate: LoadingCoordinatorDelegate?
  let window: UIWindow

  init(window: UIWindow) {
    self.window = window
  }

  func start() {
    if let navigationController = mainStoryBoard?.instantiateInitialViewController() as? UINavigationController,
      let loadingViewController = navigationController.topViewController as? LoadingViewController {
      let viewModel = LoadingViewModel()
      viewModel.coordinatorDelegate = self
      loadingViewController.viewModel = viewModel
      window.rootViewController = navigationController
    }
  }
}

extension LoadingCoordinator: LoadingViewModelCoordinatorDelegate {

  func loadingViewModelDidLoad(viewModel: LoadingViewModel) {
    self.delegate?.loadingCoordinatorDidFinish(loadingCoordinator: self)
  }
}
