//
//  BallotCollectionViewCell.swift
//  iVote
//
//  Created by Hasan Sa on 02/10/2018.
//  Copyright © 2018 Hasan Sa. All rights reserved.
//

import UIKit

class BallotCollectionViewCell: BaseCollectionViewCell {

  @IBOutlet private weak var imageView: UIImageView!
  @IBOutlet private weak var titleLabel: UILabel!
  
  override func awakeFromNib() {
    super.awakeFromNib()
  }

  func setItem(_ item: Item) {
    self.titleLabel.text = item.title
    if let image = item.image, let uiImage = UIImage(named: image) {
      self.imageView.image = uiImage
    }
    self.backgroundColor = item.backgroundColor
  }

}
