//
//  HomeViewModel.swift
//  iVote
//
//  Created by Hasan Sa on 06/10/2018.
//  Copyright © 2018 Hasan Sa. All rights reserved.
//

import Foundation
import UIKit

protocol HomeViewModelViewDelegate: AnyObject {
  func homeViewModel(didLoadStatus success: Bool)
}

protocol HomeViewModelCoordinatorDelegate: AnyObject {
  func showNomineeCounting(viewModel: HomeViewModel)
  func showSearch(viewModel: HomeViewModel)
  func showVote(viewModel: HomeViewModel)
  func showBallotsStatus(viewModel: HomeViewModel)
  func showReportCenter(viewModel: HomeViewModel)
  func logout(viewModel: HomeViewModel)
  func ballotChangeRequest(viewModel: HomeViewModel)
}

class HomeViewModel {
  weak var viewDelegate: HomeViewModelViewDelegate?
  var coordinatorDelegate: HomeViewModelCoordinatorDelegate?

  var status: Status?
  var ballots: Observable<[Ballot]> = Observable([])
  var nominees: Observable<[Nominee]> = Observable([])

  // Errors
  var errorMessage: String?

  let numberOfSections = 4

  let items = [Item(title: "סיפרה",
                      image: "ranking",
                      backgroundColor: UIColor.color(withHexString: "#6CBBFF")),
                 Item(title: "עדכון הצבעה",
                      image: "voteBox",
                      backgroundColor: UIColor.color(withHexString: "#FF6CF4")),
                 Item(title: "סטטוס קלפיות",
                      image: "vote",
                      backgroundColor: UIColor.color(withHexString: "#11D625")),
                 Item(title: "דיווחים",
                      image: "coordination",
                      backgroundColor: UIColor.color(withHexString: "#FF6CAA"))]

  init() {
    // TODO: fetch current ballot from local DB
    let currentBallotId = 1
    // getStatus
    ElectionsService.shared.status(ballotNumber: currentBallotId) { (status) in
      self.status = status
      let success = (status != nil)
      DispatchQueue.main.async {
        self.viewDelegate?.homeViewModel(didLoadStatus: success)
      }
      self.errorMessage = !success ? "could not load status data" : nil
    }
    // getAllBallots
    ElectionsService.shared.getAllBallots { ballots in
      self.ballots.value = ballots.sorted(by: { Int($0.number)! < Int($1.number)! })
    }
    // getAllNominee
    ElectionsService.shared.getAllNominee {
      self.nominees.value = $0
    }
  }

  func showNomineeCounting() {
    self.coordinatorDelegate?.showNomineeCounting(viewModel: self)
  }

  func showSearch() {
    self.coordinatorDelegate?.showSearch(viewModel: self)
  }

  func showVote() {
    self.coordinatorDelegate?.showVote(viewModel: self)
  }

  func showBallotsStatus() {
    self.coordinatorDelegate?.showBallotsStatus(viewModel: self)
  }

  func showReportCenter() {
    self.coordinatorDelegate?.showReportCenter(viewModel: self)
  }

  func logout() {
    self.coordinatorDelegate?.logout(viewModel: self)
  }

  func changeBallot() {
    self.coordinatorDelegate?.ballotChangeRequest(viewModel: self)
  }
}
