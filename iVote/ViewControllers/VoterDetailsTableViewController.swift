//
//  VoterDetailsTableViewController.swift
//  iVote
//
//  Created by Hasan Sa on 06/10/2018.
//  Copyright © 2018 Hasan Sa. All rights reserved.
//

import UIKit
import AlertBar

class VoterDetailsTableViewController: UITableViewController {

  var viewModel: VoteUpdaterViewModel? {
    didSet {
      viewModel?.viewDelegate = self
    }
  }

  private var voter: Voter? {
    return viewModel?.voter
  }
  
  @IBOutlet weak var updateVoteButton: UIButton!
  @IBOutlet private var idLable: UILabel!
  @IBOutlet private var firstNameLable: UILabel!
  @IBOutlet private var lastNameLable: UILabel!
  @IBOutlet private var fatherNameLable: UILabel!
  @IBOutlet private var motherNameLable: UILabel!
  @IBOutlet private var ballotIdLable: UILabel!
  @IBOutlet private var ballotNumberLable: UILabel!
  @IBOutlet private var phoneLable: UILabel!
  @IBOutlet private var isActiveLable: UILabel!


  override func viewDidLoad() {
    super.viewDidLoad()
    self.setVoterDetails()
    self.viewModel?.errorMessage.observe { _ in
      self.updateVoteButton.shake()
    }
  }


  private func setVoterDetails() {
    self.idLable.text = voter?.id
    self.firstNameLable.text = voter?.firstName
    self.lastNameLable.text = voter?.lastName
    self.fatherNameLable.text = voter?.fatherName
    self.motherNameLable.text = voter?.motherName
    if let ballotId = voter?.ballotId {
      self.ballotIdLable.text = "\(ballotId)"
    }
    if let ballotNumber = voter?.ballotNumber {
      self.ballotNumberLable.text = "\(ballotNumber)"
    }
    self.phoneLable.text = voter?.phoneNumber
    if let hasVoted = voter?.hasVoted {
      self.isActiveLable.text = "\(hasVoted)"
    }
  }

  @IBAction func updateVoter() {
    self.viewModel?.submit()
  }

  // MARK: - Table view data source

  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    if self.viewModel?.canUpdateVote == true {
      return 7
    }
    return 6
  }
}

extension VoterDetailsTableViewController: VoteUpdaterViewModelDelegate {
  func canSubmit() -> Bool {
    return true
  }

  func voteUpdaterViewModel(didUpdateVoter success: Bool) {
    AlertBar.show(type: .success, message: "עודכן בהצלחה")
  }


}
