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

  var path: String {
    get {
      return ElectionsService.shared.user.path
    }
    set {
      ElectionsService.shared.user.path = newValue
    }
  }
  // Errors
  var errorMessage: Observable<String?> = Observable(nil)

  init() {
    ElectionsService.shared.sites { sites in
      guard !sites.isEmpty else {
        return
      }
      let item = sites[0]
      self.path = item.path
      self.sites.value = sites
    }
  }

  func submit() {
    guard !self.path.isEmpty else {
      self.errorMessage.value = "invalid path"
      return
    }
    self.coordinatorDelegate?.regionViewModelCoordinatorDidFinish(viewModel: self)
  }
}
