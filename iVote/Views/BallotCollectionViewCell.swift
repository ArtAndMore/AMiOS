//
//  BallotCollectionViewCell.swift
//  iVote
//
//  Created by Hasan Sa on 02/10/2018.
//  Copyright © 2018 Hasan Sa. All rights reserved.
//

import UIKit

class BallotCollectionViewCell: UICollectionViewCell {

  @IBOutlet private weak var imageView: UIImageView!
  @IBOutlet private weak var titleLabel: UILabel!
  
  override func awakeFromNib() {
    super.awakeFromNib()
    // Initialization code
  }

  func set(item: Item) {
    self.titleLabel.text = item.title
    self.imageView.image = UIImage(named: item.image)
    self.backgroundColor = item.backgroundColor
  }

}
