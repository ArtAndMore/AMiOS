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

  var canUpdateVotes: Bool = false

  // Errors
  var errorMessage: Observable<String?> = Observable(nil)

  func searchVoter(withId id: String?) {
    guard let id = id, !id.isEmpty else {
      self.errorMessage.value = "invalid voter id"
      return
    }
    ElectionsService.shared.searchVoter(byId: id) { (voter, error) in
      if error == nil, let voter = voter {
        self.voter = voter
        DispatchQueue.main.async {
          self.viewDelegate?.searchViewModel(didFindVoter: voter)
        }
      } else {
        self.errorMessage.value = "Voter not exist"
      }
    }
  }

  func showVoterDetails() {
    self.coordinatorDelegate?.showVoterDetails(viewModel: self)
  }
}
