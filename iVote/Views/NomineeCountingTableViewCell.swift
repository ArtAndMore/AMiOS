//
//  NomineeCountingTableViewCell.swift
//  iVote
//
//  Created by Hasan Sa on 06/10/2018.
//  Copyright © 2018 Hasan Sa. All rights reserved.
//

import UIKit

protocol NomineeCountingTableViewCellDlegate: AnyObject {
  func countingTableViewCell(_ cell: NomineeCountingTableViewCell, stepperValueDidChange value: Int)
}

class NomineeCountingTableViewCell: UITableViewCell {

  @IBOutlet weak var nomineeLabel: UILabel!
  @IBOutlet weak var votesCountLabel: UILabel!
  @IBOutlet weak var stepper: UIStepper!

  weak var delegate: NomineeCountingTableViewCellDlegate?

  override func awakeFromNib() {
    super.awakeFromNib()
    // Initialization code
  }

  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
    // Configure the view for the selected state
  }

  @IBAction func stepperValueChangeAction(_ sender: UIStepper) {
    let value = Int(sender.value)
    votesCountLabel.text = "\(value)"
    self.delegate?.countingTableViewCell(self, stepperValueDidChange: value)
  }

}
