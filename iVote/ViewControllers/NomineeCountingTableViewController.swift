//
//  NomineeCountingTableViewController.swift
//  iVote
//
//  Created by Hasan Sa on 06/10/2018.
//  Copyright © 2018 Hasan Sa. All rights reserved.
//

import UIKit
import StatusAlert

class NomineeCountingTableViewController: TableViewController {

  private var toastFooterView: ToastView?

  var viewModel: NomineeCountingViewModel! {
    didSet {
      viewModel.viewDelegate = self
    }
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    self.title = viewModel.currentBallot
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
    cell.setNominee(name: nominee.name, count: nominee.count)
    return cell
  }

  override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 120
  }

  // set view for footer
  override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
    let footerView = ToastView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 40))
    footerView.title = StatusAlertType.update.rawValue
    self.toastFooterView = footerView
    return footerView
  }

  // set height for footer
  override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
    return 40
  }
}

extension NomineeCountingTableViewController: NomineeCountingViewModelDelegate {
  func nomineesCountingViewModelDidLoaded() {
    self.tableView?.reloadData()
  }

  func nommineeCountingViewModel(didUpdateStatus success: Bool) {
    if success {
      self.toastFooterView?.show()
    }
  }
}

extension NomineeCountingTableViewController: NomineeCountingTableViewCellDlegate {
  func countingTableViewCell(_ cell: NomineeCountingTableViewCell, stepperValueDidChange value: Int) {
    if let indexPath = self.tableView.indexPath(for: cell) {
      let nominee = viewModel.nominees[indexPath.row]
      self.viewModel.update(nomineeWithId: nominee.id, sign: value)
    }
  }
}
