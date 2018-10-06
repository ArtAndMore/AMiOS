//
//  BallotsStatusTableViewController.swift
//  iVote
//
//  Created by Hasan Sa on 06/10/2018.
//  Copyright © 2018 Hasan Sa. All rights reserved.
//

import UIKit

class BallotsStatusTableViewController: UITableViewController {

  var viewModel: BallotsStatusViewModel!

  override func viewDidLoad() {
    super.viewDidLoad()

  }

  // MARK: - Table view data source

  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    // #warning Incomplete implementation, return the number of rows
    return viewModel.ballotsStatus.count
  }

  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "BallotStatusTableViewCell", for: indexPath) as! BallotStatusTableViewCell
    return cell
  }
}
