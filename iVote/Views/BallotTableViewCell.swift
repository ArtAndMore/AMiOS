//
//  BallotTableViewCell.swift
//  iVote
//
//  Created by Hasan Sa on 06/10/2018.
//  Copyright © 2018 Hasan Sa. All rights reserved.
//

import UIKit

class BallotTableViewCell: UITableViewCell {
  
  @IBOutlet private weak var statusLabel: UILabel!
  @IBOutlet weak var progressView: UIProgressView!
  @IBOutlet weak var numberLabel: UILabel!

  override func awakeFromNib() {
    super.awakeFromNib()
    // Initialization code
  }

  func setBallot(_ ballot: Ballot) {
    self.statusLabel.text = "\(ballot.isVoted) \\ \(ballot.total)"
    self.progressView.progress = Float(ballot.isVoted)! / Float(ballot.total)!
    self.numberLabel.text = ballot.number
  }

}
