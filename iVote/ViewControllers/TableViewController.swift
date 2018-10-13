//
//  TableViewController.swift
//  iVote
//
//  Created by Hasan Sa on 13/10/2018.
//  Copyright © 2018 Hasan Sa. All rights reserved.
//

import UIKit

class TableViewController: UITableViewController {

  override func viewDidLoad() {
    super.viewDidLoad()
    let tap = UITapGestureRecognizer(target: self, action: #selector(tapHandler))
    self.tableView.addGestureRecognizer(tap)
  }

  @objc func tapHandler() {
    self.view.endEditing(true)
  }

}
