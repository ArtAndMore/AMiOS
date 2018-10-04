//
//  Theme.swift
//  Elections
//
//  Created by Hasan Sa on 27/08/2018.
//  Copyright © 2018 Hasan Sa. All rights reserved.
//

import UIKit

struct Theme {
  static let redColor = UIColor.init(red: 255/255, green: 126/255, blue: 121/255, alpha: 1)
  static let greenColor = UIColor.init(red: 0, green: 144/255, blue: 81/255, alpha: 1)
  static let mainColor = #colorLiteral(red: 0, green: 0.3294117647, blue: 0.5764705882, alpha: 1)
  static let secondColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
  static var randomMainColor: UIColor {
    return mainColor.withAlphaComponent(CGFloat.random(in: 0.5..<0.8))
  }
  
  static func configure() {
    UIBarButtonItem.appearance().tintColor = secondColor
    UITabBar.appearance().unselectedItemTintColor = secondColor
    UISegmentedControl.appearance().tintColor = secondColor
    UIToolbar.appearance().tintColor = mainColor
    UIPickerView.appearance().tintColor = mainColor
  }
}
