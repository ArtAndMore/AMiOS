//
//  Observable.swift
//  iVote
//
//  Created by Hasan Sa on 08/10/2018.
//  Copyright © 2018 Hasan Sa. All rights reserved.
//

import Foundation

class Observable<T> {
  typealias Listener =  (T) -> Void
  private var listener: Listener?
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

  func observe(listener: Listener?) {
    self.listener = listener
    if let value = self.value {
      queue.async {
        listener?(value)
      }
    }
  }
}
