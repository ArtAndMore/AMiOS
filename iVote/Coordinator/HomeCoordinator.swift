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

  let user: User

  let window: UIWindow

  init(window: UIWindow, user: User) {
    self.window = window
    self.user = user
  }

  func start() {
    if let navigationController = mainStoryBoard?.instantiateViewController(withIdentifier: "HomeNavigationViewController") as? UINavigationController,
      let homeViewCintroller = navigationController.topViewController as? HomeViewController {
      let viewModel = HomeViewModel(user: self.user)
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
      let nomineeViewModel = NomineeCountingViewModel()
      nomineeViewModel.currentBallot = viewModel.currentBallot
      if let nominees = viewModel.nominees.value {
        if nominees.isEmpty {
          viewModel.nominees.observe(listener: { nomineeViewModel.nominees = $0 })
        } else {
          nomineeViewModel.nominees = nominees
        }
      }
      nomineeVC.viewModel = nomineeViewModel
      navigationController.pushViewController(nomineeVC, animated: true)
    }
  }

  func showSearch(viewModel: HomeViewModel) {
    if let searchVC = mainStoryBoard?.instantiateViewController(withIdentifier: "SearchViewController") as? SearchViewController,
      let navigationController = window.rootViewController as? UINavigationController {
      let viewModel = SearchViewModel()
      viewModel.coordinatorDelegate = self
      searchVC.viewModel = viewModel
      navigationController.pushViewController(searchVC, animated: true)
    }
  }

  func showVote(viewModel: HomeViewModel) {
    if let voteUpdaterVC = mainStoryBoard?.instantiateViewController(withIdentifier: "VoteUpdaterViewController") as? VoteUpdaterViewController,
      let navigationController = window.rootViewController as? UINavigationController {
      let updateViewModel = VoteUpdaterViewModel()
      updateViewModel.canUpdateVote = viewModel.permission.value??.canUpdateVotes ?? false
      voteUpdaterVC.viewModel = updateViewModel
      navigationController.pushViewController(voteUpdaterVC, animated: true)
    }
  }

  func showBallotsStatus(viewModel: HomeViewModel) {
    if let ballotsStatusVC = mainStoryBoard?.instantiateViewController(withIdentifier: "BallotsStatusTableViewController") as? BallotsStatusTableViewController,
      let navigationController = window.rootViewController as? UINavigationController {
      let ballotViewModel = BallotViewModel()
      if let ballots = viewModel.ballots.value {
        if ballots.isEmpty {
          viewModel.ballots.observe(listener: { ballotViewModel.ballots = $0 })
        } else {
          ballotViewModel.ballots = ballots
        }
      }

      ballotsStatusVC.viewModel = ballotViewModel
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

extension HomeCoordinator: SearchViewModelCoordinatorDelegate {
  func showVoterDetails(viewModel: SearchViewModel) {
    if let voterVC = mainStoryBoard?.instantiateViewController(withIdentifier: "VoterDetailsTableViewController") as? VoterDetailsTableViewController,
      let navigationController = window.rootViewController as? UINavigationController {
      let voteUpdateViewModel = VoteUpdaterViewModel()
      voteUpdateViewModel.voter = viewModel.voter
      voterVC.viewModel = voteUpdateViewModel
      navigationController.pushViewController(voterVC, animated: true)
    }
  }


}
