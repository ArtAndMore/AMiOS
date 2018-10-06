//
//  Helper.swift
//  iVote
//
//  Created by Hasan Sa on 26/08/2018.
//  Copyright © 2018 Hasan Sa. All rights reserved.
//

import Foundation
import UIKit

class Box<T> {
  typealias Listener =  (T) -> Void
  var listener: Listener?
  private var queue: DispatchQueue
  
  var value: T? = nil {
    didSet {
      if let val = value {
        queue.async {
          self.listener?(val)
        }
      }
    }
  }
  
  init(_ value: T?, queue: DispatchQueue = DispatchQueue.main) {
    self.value = value
    self.queue = queue
  }
  
  func bind(listener: Listener?) {
    self.listener = listener
    if let value = self.value {
      queue.async {
        listener?(value)
      }
    }
  }
}

extension UIView {
  static func nib() -> UINib {
    return UINib(nibName: String(describing: self), bundle: Bundle(for: self))
  }

  enum ViewSide {
    case left, right, top, bottom
  }

  func addBorder(toSide side: ViewSide, withColor color: CGColor, andThickness thickness: CGFloat, margin: CGFloat = 0.0) {
    let border = CALayer()
    border.backgroundColor = color

    switch side {
    case .left:
      border.frame = CGRect(x: bounds.minX - margin, y: bounds.minY, width: thickness, height: bounds.height)
    case .right:
      border.frame = CGRect(x: bounds.maxX + margin, y: bounds.minY, width: thickness, height: bounds.height)
    case .top:
      border.frame = CGRect(x: bounds.minX, y: bounds.minY - margin, width: bounds.width, height: thickness)
    case .bottom:
      border.frame = CGRect(x: bounds.minX, y: bounds.maxY + margin, width: bounds.width, height: thickness)
    }

    layer.addSublayer(border)
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
