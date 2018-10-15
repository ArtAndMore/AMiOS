// MIT License
//
// Copyright (c) 2018 Gallagher Group Ltd
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.
import Foundation
import UIKit

/// Available toast font sizes
enum ToastSize {
  /// Corresponds to UIFontTextStyle.body
  case small
  /// Corresponds to UIFontTextStyle.title2
  case normal
  /// Corresponds to UIFontTextStyle.title1
  case large
}
enum ToastDuration : TimeInterval {
  case short = 0.5, normal = 1.5, long = 3.5
}


private class PaddingLabel: UILabel {

  var textInsets = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5) {
    didSet {
      invalidateIntrinsicContentSize()
    }
  }

  override func textRect(forBounds bounds: CGRect, limitedToNumberOfLines numberOfLines: Int) -> CGRect {
    let insetRect = bounds.inset(by: textInsets)
    let textRect = super.textRect(forBounds: insetRect, limitedToNumberOfLines: numberOfLines)
    let invertedInsets = UIEdgeInsets(top: -textInsets.top,
                                      left: -textInsets.left,
                                      bottom: -textInsets.bottom,
                                      right: -textInsets.right)
    return textRect.inset(by: invertedInsets)
  }

  override func drawText(in rect: CGRect) {
    super.drawText(in: rect.inset(by: textInsets))
  }
}

class Toast {

  private static let instance = Toast()

  private var label: PaddingLabel?
  /// Creates a toast message as a subview of a given UIView
  ///
  /// - parameter message: The text to display
  /// - parameter size: The text size
  /// - parameter duration: How long to display the toast message for
  static func toast(_ message:String, size:ToastSize = .small, duration: ToastDuration = .short, in view: UIView) {
    guard instance.label == nil else {
      DispatchQueue.main.asyncAfter(deadline: .now() + duration.rawValue) {
        toast(message, size: size, duration: duration, in: view)
      }
      return
    }
    let label = PaddingLabel()
    label.textColor = UIColor.white
    label.backgroundColor = UIColor.black
    label.text = message
    label.textAlignment = .center
    label.translatesAutoresizingMaskIntoConstraints = false
    label.alpha = 0
    label.numberOfLines = 0

    switch size {
    case .small:
      label.font = UIFont.preferredFont(forTextStyle: .body)
    case .normal:
      label.font = UIFont.preferredFont(forTextStyle: .title2)
    case .large:
      label.font = UIFont.preferredFont(forTextStyle: .title1)
    }

    label.clipsToBounds = true
    label.layer.cornerRadius = 5

    view.addSubview(label)

    label.translatesAutoresizingMaskIntoConstraints = false
    label.bottomAnchor.constraint(equalTo: view.bottomAnchor,
                                                 constant: -40).isActive = true
    label.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true

    instance.label = label
    UIView.animate(withDuration: 0.1, animations: {
      label.alpha = 0.7
    }, completion: { _ in
      UIView.animate(withDuration: 1.2, delay: duration.rawValue, options:.curveEaseOut, animations: {
        label.alpha = 0
      }, completion: { _ in
        instance.label?.removeFromSuperview()
        instance.label = nil
      }) })
  }
}

/// Creates a toast message as a subview of the application's key window
///
/// - parameter message: The text to display
/// - parameter size: The text size
/// - parameter duration: How long to display the toast message for
func toast(_ message:String, size:ToastSize, duration: ToastDuration) {
  guard let window = UIApplication.shared.keyWindow else {
    return
  }
  Toast.toast(message, size: size, duration: duration, in: window)
}
