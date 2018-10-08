//
//  BallotsStatusTableViewController.swift
//  iVote
//
//  Created by Hasan Sa on 06/10/2018.
//  Copyright © 2018 Hasan Sa. All rights reserved.
//

import UIKit

class BallotsStatusTableViewController: UITableViewController {

  var viewModel: BallotViewModel! {
    didSet {
      viewModel.viewDelegate = self
    }
  }

  override func viewDidLoad() {
    super.viewDidLoad()

  }

  // MARK: - Table view data source

  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    // #warning Incomplete implementation, return the number of rows
    return viewModel.ballots.count
  }

  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "BallotTableViewCell", for: indexPath) as! BallotTableViewCell
    let ballot = viewModel.ballots[indexPath.row]
    cell.setBallot(ballot)
    return cell
  }

  override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 64
  }
}

extension BallotsStatusTableViewController: BallotViewModelDelegate {
  func ballotViewModelDidLoadBallots() {
    self.tableView?.reloadData()
  }


}
