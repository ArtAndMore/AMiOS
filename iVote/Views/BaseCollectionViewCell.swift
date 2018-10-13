//
//  BaseCollectionViewCell.swift
//  iVote
//
//  Created by Hasan Sa on 08/10/2018.
//  Copyright © 2018 Hasan Sa. All rights reserved.
//

import UIKit

class BaseCollectionViewCell: UICollectionViewCell {

  private var isLoading: Bool = false

  override func awakeFromNib() {
    super.awakeFromNib()
  }

  func showLoading() {
    if !isLoading {
      isLoading = true

    }
  }

  func hideLoading() {
    if isLoading {
      isLoading = false
    }
  }

}
