//
//  CountingLabel.swift
//  iVote
//
//  Created by Hasan Sa on 08/10/2018.
//  Copyright © 2018 Hasan Sa. All rights reserved.
//

import UIKit

class CountingLabel: UILabel {

  fileprivate var startingValue:CGFloat = 0

  fileprivate var destinationValue:CGFloat = 0

  fileprivate var progress:TimeInterval = TimeInterval()

  fileprivate var lastUpdate:TimeInterval = TimeInterval()

  fileprivate var totalTime:TimeInterval = TimeInterval()

  fileprivate var displayLink:CADisplayLink?

  func animate(to endValue : CGFloat, duration: TimeInterval, delay: TimeInterval = 0.0) {

    var startingValue = self.currentValue()
    if startingValue == endValue {
      startingValue = 0.0
    }
    DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
      self.countFrom(startingValue, endValue: endValue, duration: duration)
    }
  }

}

private extension CountingLabel {
   func countFrom(_ startValue:CGFloat, endValue:CGFloat, duration:TimeInterval) {
    self.startingValue = startValue
    self.destinationValue = endValue

    self.resetDisplayLink()

    if (duration <= 0.0) {
      self.text = NSString(format:"%.0lf", Double(endValue)) as String
      return
    } else {
      self.progress = 0
      self.totalTime = duration
      self.lastUpdate = Date.timeIntervalSinceReferenceDate


      let displayLink = CADisplayLink(target: self, selector: #selector(updateValue(_:)))
      displayLink.add(to: RunLoop.current, forMode: RunLoop.Mode.common)
      displayLink.add(to: RunLoop.current, forMode: RunLoop.Mode.tracking)

      self.displayLink = displayLink
    }
  }

  @objc  func updateValue(_ displayLink:CADisplayLink) {
    let now = Date.timeIntervalSinceReferenceDate

    self.progress = self.progress + now - self.lastUpdate
    self.lastUpdate = now

    if (self.progress >= self.totalTime) {
      self.resetDisplayLink()
      self.progress = self.totalTime
    }
    self.text = NSString(format:"%.0lf", Double(self.currentValue())) as String
  }

   func resetDisplayLink() {

    self.displayLink?.remove(from: RunLoop.main, forMode:RunLoop.Mode.common)
    self.displayLink?.remove(from: RunLoop.current, forMode: RunLoop.Mode.tracking)
    self.displayLink = nil
  }

   func currentValue()->CGFloat {
    if (self.progress >= self.totalTime) {
      return self.destinationValue
    }
    return CGFloat(Double(self.startingValue) + Double(self.progress / self.totalTime) * Double(self.destinationValue - self.startingValue))
  }


}
