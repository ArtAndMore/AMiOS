//
//  HomeCoordinator.swift
//  iVote
//
//  Created by Hasan Sa on 06/10/2018.
//  Copyright © 2018 Hasan Sa. All rights reserved.
//

import UIKit

protocol HomeCoordinatorDelegate: AnyObject {
  func logout(coordinator: HomeCoordinator)
}

class HomeCoordinator: Coordinator {
  weak var delegate: HomeCoordinatorDelegate?

  let window: UIWindow

  init(window: UIWindow) {
    self.window = window
  }

  func start() {
    if let navigationController = mainStoryBoard?.instantiateViewController(withIdentifier: "HomeViewController") as? UINavigationController,
      let homeViewCintroller = navigationController.topViewController as? HomeViewController {
      let viewModel = HomeViewModel()
      viewModel.coordinatorDelegate = self
      homeViewCintroller.viewModel = viewModel
      window.rootViewController = navigationController
    }
  }

}

extension HomeCoordinator: HomeViewModelCoordinatorDelegate {
  func showNomineeCounting(viewModel: HomeViewModel) {
    if let nomineeVC = mainStoryBoard?.instantiateViewController(withIdentifier: "NomineeCountingTableViewController") as? NomineeCountingTableViewController,
      let navigationController = window.rootViewController as? UINavigationController {
      nomineeVC.viewModel = NomineeCountingViewModel()
      navigationController.pushViewController(nomineeVC, animated: true)
    }
  }

  func showSearch(viewModel: HomeViewModel) {
    if let searchVC = mainStoryBoard?.instantiateViewController(withIdentifier: "SearchViewController") as? SearchViewController,
      let navigationController = window.rootViewController as? UINavigationController {
      let viewModel = SearchViewModel()
      searchVC.viewModel = viewModel
      navigationController.pushViewController(searchVC, animated: true)
    }
  }

  func showVote(viewModel: HomeViewModel) {
    if let voteUpdaterVC = mainStoryBoard?.instantiateViewController(withIdentifier: "VoteUpdaterViewController") as? VoteUpdaterViewController,
      let navigationController = window.rootViewController as? UINavigationController {
      voteUpdaterVC.viewModel = VoteUpdaterViewModel()
      navigationController.pushViewController(voteUpdaterVC, animated: true)
    }
  }

  func showBallotsStatus(viewModel: HomeViewModel) {
    if let ballotsStatusVC = mainStoryBoard?.instantiateViewController(withIdentifier: "BallotsStatusTableViewController") as? BallotsStatusTableViewController,
      let navigationController = window.rootViewController as? UINavigationController {
      ballotsStatusVC.viewModel = BallotsStatusViewModel()
      navigationController.pushViewController(ballotsStatusVC, animated: true)
    }
  }

  func showReportCenter(viewModel: HomeViewModel) {
    if let reportCenterVC = mainStoryBoard?.instantiateViewController(withIdentifier: "ReportCenterViewController") as? ReportCenterViewController,
      let navigationController = window.rootViewController as? UINavigationController {
      reportCenterVC.viewModel = ReportCenterViewModel()
      navigationController.pushViewController(reportCenterVC, animated: true)
    }
  }

  func logout(viewModel: HomeViewModel) {
    self.delegate?.logout(coordinator: self)
  }

  func ballotChangeRequest(viewModel: HomeViewModel) {

  }
}
