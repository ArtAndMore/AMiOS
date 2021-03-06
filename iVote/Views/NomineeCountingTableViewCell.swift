//
//  NomineeCountingTableViewCell.swift
//  iVote
//
//  Created by Hasan Sa on 06/10/2018.
//  Copyright © 2018 Hasan Sa. All rights reserved.
//

import UIKit
import GMStepper

protocol NomineeCountingTableViewCellDlegate: AnyObject {
  func countingTableViewCell(_ cell: NomineeCountingTableViewCell, stepperValueDidChange value: Int)
}

class NomineeCountingTableViewCell: UITableViewCell {

  @IBOutlet weak var nomineeLabel: UILabel!
  @IBOutlet weak var stepper: GMStepper! {
    didSet {
      stepper.addTarget(self, action: #selector(stepperValueChanged), for: .valueChanged)
    }
  }

  var currentValue: Double = 0

  weak var delegate: NomineeCountingTableViewCellDlegate?

  override func awakeFromNib() {
    super.awakeFromNib()
    // Initialization code
  }

  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
    // Configure the view for the selected state
  }

  @objc func stepperValueChanged(stepper: GMStepper) {
    let countValue = (stepper.value > currentValue) ? 1 : -1
    self.currentValue = stepper.value
    self.delegate?.countingTableViewCell(self, stepperValueDidChange: Int(countValue))
  }

}
