//
//  Helper.swift
//  iVote
//
//  Created by Hasan Sa on 26/08/2018.
//  Copyright © 2018 Hasan Sa. All rights reserved.
//

import Foundation
import UIKit
import StatusAlert

enum StatusAlertType {
  case noConnection
  case update
  case send
}

extension UIResponder {
  func showAlert(withStatus status: StatusAlertType) {
    var image: UIImage?
    var title: String?
    switch status {
    case .noConnection:
      image = UIImage(named: "no-wifi")
      title = "אין חיבור אינטרנט"
    case .update:
      image = UIImage(named: "check")
      title = "עודכן בהצלחה"
    case .send:
      image = UIImage(named: "check")
      title = "נשלח בהצלחה"
    }

    let statusAlert = StatusAlert()
    statusAlert.image = image
    statusAlert.title = title
    statusAlert.canBePickedOrDismissed = true
    // Presenting created instance
    statusAlert.showInKeyWindow()
  }
}

extension UIView {
  static func nib() -> UINib {
    return UINib(nibName: String(describing: self), bundle: Bundle(for: self))
  }

  func shake() {
    let animation = CAKeyframeAnimation(keyPath: "transform.translation.x");
    animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.linear)
    animation.values = [-5, 5, -5, 5, -3, 3, -2, 2, 0]
    animation.duration = 0.4
    self.layer.add(animation, forKey: "shake")
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

