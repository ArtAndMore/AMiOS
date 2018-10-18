//
//  BallotsStatusTableViewController.swift
//  iVote
//
//  Created by Hasan Sa on 06/10/2018.
//  Copyright © 2018 Hasan Sa. All rights reserved.
//

import UIKit

class BallotsStatusTableViewController: UITableViewController {

  var viewModel: BallotViewModel!

  override func viewDidLoad() {
    super.viewDidLoad()

    viewModel.ballots.observe { _ in
      self.tableView.reloadData()
    }

  }

  // MARK: - Table view data source

  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    // #warning Incomplete implementation, return the number of rows
    return viewModel.ballots.value?.count ?? 0
  }

  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "BallotTableViewCell", for: indexPath) as! BallotTableViewCell
    if let ballot = viewModel.ballots.value?[indexPath.row] {
      cell.setBallot(ballot)
    }
    return cell
  }

  override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 64
  }
}
