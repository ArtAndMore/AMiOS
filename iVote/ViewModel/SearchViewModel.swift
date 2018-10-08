//
//  SearchViewModel.swift
//  iVote
//
//  Created by Hasan Sa on 06/10/2018.
//  Copyright © 2018 Hasan Sa. All rights reserved.
//

import Foundation

protocol SearchViewModelCoordinatorDelegate: AnyObject {
  func showVoterDetails(viewModel: SearchViewModel)
}

protocol SearchViewModelDelegate: AnyObject {
  func searchViewModel(didFindVoter voter: Voter)
}

class SearchViewModel {
  var coordinatorDelegate: SearchViewModelCoordinatorDelegate?
  weak var viewDelegate: SearchViewModelDelegate?

  private(set) var voter: Voter?

  // Errors
  var errorMessage: String?

  func searchVoter(withId id: String?) {
    guard let id = id else {
      return
    }
    ElectionsService.shared.searchVoter(byId: id) { voter in
      if let voter = voter {
        self.voter = voter
        DispatchQueue.main.async {
          self.viewDelegate?.searchViewModel(didFindVoter: voter)
        }
      } else {
        self.errorMessage = "Voter Not Exist"
      }
    }
  }

  func showVoterDetails() {
    self.coordinatorDelegate?.showVoterDetails(viewModel: self)
  }
}
