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

class ToastView: UIView {

  private lazy var titleLabel: UILabel = {
    let label = PaddingLabel()
    label.textColor = UIColor.white
    label.backgroundColor = UIColor.black
    label.textAlignment = .center
    label.numberOfLines = 0
    label.clipsToBounds = true
    label.layer.cornerRadius = 5
    label.translatesAutoresizingMaskIntoConstraints = false
    return label
  }()

  private lazy var headerView: UIView = {
    let headerView = UIView()
    headerView.addSubview(titleLabel)
    headerView.translatesAutoresizingMaskIntoConstraints = false
    return headerView
  }()

  var title: String = "" {
    didSet {
      titleLabel.text = title
      self.setNeedsUpdateConstraints()
    }
  }

  var size: ToastSize = .small {
    didSet {
      switch size {
      case .small:
        titleLabel.font = UIFont.preferredFont(forTextStyle: .body)
      case .normal:
        titleLabel.font = UIFont.preferredFont(forTextStyle: .title2)
      case .large:
        titleLabel.font = UIFont.preferredFont(forTextStyle: .title1)
      }
    }
  }

  override init(frame: CGRect) {
    super.init(frame: frame)
    setupView()
  }

  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    setupView()
  }

  func show() {
    guard (self.layer.animation(forKey: "INOUT") == nil) else {
      return
    }
    //FADE IN OUT
    let animation = CAKeyframeAnimation(keyPath: "opacity")
    animation.values = [ 0, 0.3, 0.5, 0.7, 0.7, 0.7, 0.5, 0.3, 0 ]
    animation.duration = 1.2
    animation.timingFunctions = [CAMediaTimingFunction(name: .easeIn), CAMediaTimingFunction(name:.easeOut)]
    animation.isAdditive = true

    let group = CAAnimationGroup()
    group.duration = 1.0
    group.animations = [animation]
    self.layer.add(group, forKey: "INOUT")
  }

  func hide() {
    self.layer.opacity = 0
  }

  private func setupView() {
    addSubview(headerView)
    setupLayout()
    UIView.setAnimationBeginsFromCurrentState(true)
    hide()
  }

  private func setupLayout() {
    titleLabel.bottomAnchor.constraint(equalTo: headerView.bottomAnchor).isActive = true
    titleLabel.centerXAnchor.constraint(equalTo: headerView.centerXAnchor).isActive = true

    headerView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
    headerView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
    headerView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
    headerView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
  }

  override class var requiresConstraintBasedLayout: Bool {
    return true
  }
}
