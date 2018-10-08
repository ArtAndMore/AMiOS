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
  var permission: Observable<Permission?> = Observable(nil)
  var ballots: Observable<[Ballot]> = Observable([])
  var nominees: Observable<[Nominee]> = Observable([])

  var items: [Int: [Item]] = [:]

  // Errors
  var errorMessage: String?

  init(username: String?) {
    if let username = username {
      ElectionsService.shared.user.name = username
    }
    // load user permistions
    ElectionsService.shared.permission { permission in
      guard let permission = permission else { return }
      self.items = self.generateItems(byUserPermission: permission)
      self.permission.value = permission


      // getStatus
      if permission.canReadStatistics
//        let ballot = permission.ballots.first, let number = Int(ballot.name)
      {
        ElectionsService.shared.status(ballotNumber: 1) { (status) in
          self.status.value = status
          let success = (status != nil)
          self.errorMessage = !success ? "could not load status data" : nil
        }
      }
      // getAllBallots
      if permission.canReadBallots {
        ElectionsService.shared.getAllBallots { ballots in
          self.ballots.value = ballots.sorted(by: { Int($0.number)! < Int($1.number)! })
        }
      }
      // getAllNominee
      if permission.canUpdateNomineeCount {
        ElectionsService.shared.getAllNominee {
          self.nominees.value = $0
        }
      }

    }
  }

  private func generateItems(byUserPermission permission: Permission) -> [Int: [Item]] {
    var result: [Int: [Item]] = [:]
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
