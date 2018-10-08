//
//  Helper.swift
//  iVote
//
//  Created by Hasan Sa on 26/08/2018.
//  Copyright © 2018 Hasan Sa. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
  static func nib() -> UINib {
    return UINib(nibName: String(describing: self), bundle: Bundle(for: self))
  }

  func addBlurBackground(style: UIBlurEffect.Style = .regular) -> UIVisualEffectView {
    let blurEffect = UIBlurEffect(style: style)
    let blurBackground = UIVisualEffectView(effect: blurEffect)

    addSubview(blurBackground)

    blurBackground.translatesAutoresizingMaskIntoConstraints = false
    blurBackground.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
    blurBackground.topAnchor.constraint(equalTo: topAnchor).isActive = true
    blurBackground.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
    blurBackground.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true

    return blurBackground
  }
}

extension Bool {
  init(_ string: String?) {
    guard let string = string else { self = false; return }

    switch string.lowercased() {
    case "true", "yes", "1":
      self = true
    default:
      self = false
    }
  }
}

extension UIColor {
  static func color(withHexString hex:String) -> UIColor {
    var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
    
    if (cString.hasPrefix("#")) {
      cString.remove(at: cString.startIndex)
    }
    
    if ((cString.count) != 6) {
      return UIColor.gray
    }
    
    var rgbValue:UInt32 = 0
    Scanner(string: cString).scanHexInt32(&rgbValue)
    
    return UIColor(
      red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
      green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
      blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
      alpha: CGFloat(1.0)
    )
  }
}

