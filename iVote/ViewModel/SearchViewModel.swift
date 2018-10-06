//
//  SearchViewModel.swift
//  iVote
//
//  Created by Hasan Sa on 06/10/2018.
//  Copyright © 2018 Hasan Sa. All rights reserved.
//

import Foundation

protocol SearchViewModelDelegate: AnyObject {
  func searchViewModel(didFindVoters voters: [Voter])
}

class SearchViewModel {
  var viewDelegate: SearchViewModelDelegate?

  var voters: [Voter] = []

  func searchVoter(withId id: String?) {
    guard let _ = id else {
      return
    }
    // TODO: execute search request via Elections service
    let voter = Voter(id: "301876298")
    voter.ballotId = 9000
    voter.ballotNumber = 200
    voter.firstName = "hasan"
    voter.lastName = "sawaed"
    voter.hasVoted = false
    voters.append(voter)
    self.viewDelegate?.searchViewModel(didFindVoters: voters)
  }
}
