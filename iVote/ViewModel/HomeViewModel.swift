//
//  HomeViewModel.swift
//  iVote
//
//  Created by Hasan Sa on 06/10/2018.
//  Copyright © 2018 Hasan Sa. All rights reserved.
//

import Foundation
import UIKit

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
  var coordinatorDelegate: HomeViewModelCoordinatorDelegate?

  var status: Observable<Status?> = Observable(nil)

  var permission: Permission? {
    return UserAuth.shared.user.permission
  }

  var allowedBallots: [Ballot] {
    return UserAuth.shared.allowedBallots
  }

  var nominees: Observable<Bool> = Observable(false)

  var items: [Int: [Item]] = [:]

  // Errors
  var errorMessage: Observable<String?> = Observable(nil)

  var currentBallot: String {
    get {
      return ElectionsService.shared.currentBallot
    }
    set {
      ElectionsService.shared.currentBallot = newValue
      self.getBallotStatus(withPermission: self.permission)
    }
  }

  init() {
    self.items = self.generateItems(byUserPermission: permission)
  }

  fileprivate func getBallotStatus(withPermission permission: Permission?) {
    guard let permission = permission, permission.canReadStatistics else {
      return
    }
    // getStatus
    ElectionsService.shared.statusForCurrentBallot() { (status, error) in
      self.status.value = status
      let success = (error == nil && status != nil)
      self.errorMessage.value = !success ? "could not load status data" : nil
    }
  }


  private func generateItems(byUserPermission permission: Permission?) -> [Int: [Item]] {
    var result: [Int: [Item]] = [:]

    guard let permission = permission else {
      return result
    }
    
    var key = -1
    if permission.canReadStatistics {
      key += 1
      result[key] = [Item(type: .statistics)]
    }
    if permission.canQuery {
      key += 1
      result[key] = [Item(type: .query)]
    }
    var extraItems: [Item] = []
    if permission.canUpdateNomineeCount {
      let item = Item.init(type: .ranking, title: "סיפרה", image: "ranking", backgroundColor: UIColor.color(withHexString: "#6CBBFF"))
      extraItems.append(item)
    }
    if permission.canUpdateVotes {
      let item = Item.init(type: .voting, title: "עדכון הצבעה", image: "voteBox", backgroundColor: UIColor.color(withHexString: "#FF6CF4"))
      extraItems.append(item)
    }
    if permission.canReadBallots {
      let item = Item.init(type: .status, title: "סטטוס קלפיות", image: "vote", backgroundColor: UIColor.color(withHexString: "#11D625"))
      extraItems.append(item)
    }
    if permission.canReportIssue {
      let item = Item.init(type: .report, title: "דיווחים", image: "coordination", backgroundColor: UIColor.color(withHexString: "#FF6CAA"))
      extraItems.append(item)
    }
    if !extraItems.isEmpty {
      key += 1
      result[key] = extraItems
    }

    return result
  }

}

extension HomeViewModel {

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
