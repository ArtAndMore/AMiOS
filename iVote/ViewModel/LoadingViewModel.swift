//
//  LoadingViewModel.swift
//  iVote
//
//  Created by Hasan Sa on 18/10/2018.
//  Copyright © 2018 Hasan Sa. All rights reserved.
//

import UIKit

protocol LoadingViewModelCoordinatorDelegate: AnyObject {
  func loadingViewModelDidLoad(viewModel: LoadingViewModel)
}

class LoadingViewModel {
  var coordinatorDelegate: LoadingViewModelCoordinatorDelegate?

  init() {
    UserAuth.shared.authenticatedUser { _ in
      DispatchQueue.main.async {
        self.coordinatorDelegate?.loadingViewModelDidLoad(viewModel: self)
      }
    }
  }
}
