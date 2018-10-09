//
//  BallotStatisticsCollectionViewCell.swift
//  iVote
//
//  Created by Hasan Sa on 02/10/2018.
//  Copyright © 2018 Hasan Sa. All rights reserved.
//

import UIKit

class BallotStatisticsCollectionViewCell: BaseCollectionViewCell {

  @IBOutlet private weak var totalVotedLabel: CountingLabel! {
    didSet {
      totalVotedLabel.text = "0"
    }
  }
  @IBOutlet private weak var dateLabel: UILabel!  {
    didSet {
      dateLabel.text = "N/A"
    }
  }
  @IBOutlet private weak var progressView: UIProgressView!  {
    didSet {
      progressView.progress = 0.0
    }
  }
  @IBOutlet private weak var percentageLabel: UILabel!  {
    didSet {
      percentageLabel.text = "0 %"
    }
  }

  private var date: String {
    let dateformatter = DateFormatter()
    dateformatter.timeStyle = DateFormatter.Style.short
    return dateformatter.string(from: Date())
  }
  override func awakeFromNib() {
    super.awakeFromNib()
  }


  func setStatus(_ status: Status?) {
    if let totalCount = status?.voters.total, totalCount != self.totalVotedLabel.text, let votedCount = status?.voters.isVoted {
      totalVotedLabel.animate(to: CGFloat((totalCount as NSString).floatValue), duration: 0.3, delay: 0.3)
      dateLabel.text = date
      progressView.progress = Float(votedCount)! / Float(totalCount)!
      percentageLabel.text = status?.voters.votingPercentage
    }

  }

}
