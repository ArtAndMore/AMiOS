//
//  CodeValidationCoordinator.swift
//  iVote
//
//  Created by Hasan Sa on 06/10/2018.
//  Copyright © 2018 Hasan Sa. All rights reserved.
//

import Foundation
import UIKit

protocol CodeValidationCoordinatorDelegate: AnyObject {
  func codeValidationCoordinatorDidFinish(codeValidationCoordinator: CodeValidationCoordinator)
}

class CodeValidationCoordinator: Coordinator {
  weak var delegate: CodeValidationCoordinatorDelegate?
  let window: UIWindow

  init(window: UIWindow) {
    self.window = window
  }

  func start() {
    if let vc = mainStoryBoard?.instantiateViewController(withIdentifier: "CodeValidationViewController") as? CodeValidationViewController,
      let navigationController = window.rootViewController as? UINavigationController {
      let viewModel = CodeValidationViewModel()
      viewModel.coordinatorDelegate = self
      vc.viewModel = viewModel
      navigationController.pushViewController(vc, animated: true)
    }
  }
}

extension CodeValidationCoordinator: CodeValidationViewModelCoordinatorDelegate {
  func codeValidationViewModelDidEnterCode(viewModel: CodeValidationViewModel) {
    delegate?.codeValidationCoordinatorDidFinish(codeValidationCoordinator: self)
  }
}
