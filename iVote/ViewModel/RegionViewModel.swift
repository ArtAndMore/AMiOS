//
//  RegionViewModel.swift
//  iVote
//
//  Created by Hasan Sa on 09/10/2018.
//  Copyright © 2018 Hasan Sa. All rights reserved.
//

import Foundation

protocol RegionViewModelCoordinatorDelegate: AnyObject {
  func regionViewModelCoordinatorDidFinish(viewModel: RegionViewModel)
}

class RegionViewModel {
  var coordinatorDelegate: RegionViewModelCoordinatorDelegate?

  var sites: Observable<[Site]> = Observable([])

  init() {
    ElectionsService.shared.sites { sites in
      guard !sites.isEmpty else {
        return
      }
      let item = sites[0]
      ElectionsService.shared.user.path = item.path
      self.sites.value = sites
    }
  }

  func login() {
    self.coordinatorDelegate?.regionViewModelCoordinatorDidFinish(viewModel: self)
  }
}
