//
//  NomineeCountingTableViewController.swift
//  iVote
//
//  Created by Hasan Sa on 06/10/2018.
//  Copyright © 2018 Hasan Sa. All rights reserved.
//

import UIKit

class NomineeCountingTableViewController: UITableViewController {

  var viewModel: NomineeCountingViewModel! {
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
    return viewModel.nominees.count
  }

  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "NomineeCountingTableViewCell") as! NomineeCountingTableViewCell
    cell.delegate = self
    let nominee = viewModel.nominees[indexPath.row]
    cell.nomineeLabel.text = nominee.name
    return cell
  }

  override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 64.0
  }

}

extension NomineeCountingTableViewController: NomineeCountingViewModelDelegate {
  func nomineesCountingDidLoaded() {
    self.tableView?.reloadData()
  }

  func nommineeCountingDidUpdateStatus() {
  }
}

extension NomineeCountingTableViewController: NomineeCountingTableViewCellDlegate {
  func countingTableViewCell(_ cell: NomineeCountingTableViewCell, stepperValueDidChange value: Int) {
    if let index = self.tableView.indexPath(for: cell) {
      self.viewModel.update(nomineeAtIndex: index.row, status: value)
    }
  }
}
