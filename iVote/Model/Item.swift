//
//  Item.swift
//  iVote
//
//  Created by Hasan Sa on 08/10/2018.
//  Copyright © 2018 Hasan Sa. All rights reserved.
//

import Foundation
import UIKit

enum ItemType {
  case statistics
  case query
  case ranking
  case voting
  case status
  case report
}

struct Item {
  var title: String?
  var image: String?
  var backgroundColor: UIColor?
  let type: ItemType
  
  init(type: ItemType, title: String?, image: String?, backgroundColor: UIColor?) {
    self.type = type
    self.title = title
    self.image = image
    self.backgroundColor = backgroundColor
  }

  init(type: ItemType) {
    self.type = type
  }
}
