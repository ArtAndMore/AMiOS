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
  var viewDelegate: HomeViewModelViewDelegate?
  var coordinatorDelegate: HomeViewModelCoordinatorDelegate?

  struct Item {
    let title: String
    let image: String
    let backgroundColor: UIColor
  }

  let page = [0:[""],
              1:[""],
              2:[Item(title: "סיפרה",
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
                      backgroundColor: UIColor.color(withHexString: "#FF6CAA"))]]

  init() {
    // TODO: execute get status request via Elections Service
  }

  func item(atIndexPath indexPath: IndexPath) -> Item? {
    return page[indexPath.section]?[indexPath.row] as? Item
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
