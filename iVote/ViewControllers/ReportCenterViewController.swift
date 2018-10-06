//
//  ReportCenterViewController.swift
//  iVote
//
//  Created by Hasan Sa on 06/10/2018.
//  Copyright © 2018 Hasan Sa. All rights reserved.
//

import UIKit

class ReportCenterViewController: UIViewController {

  @IBOutlet private weak var scrollView: UIScrollView!
  @IBOutlet private weak var stabilizationSwitch: UISwitch!
  @IBOutlet private weak var spectatorSwitch: UISwitch!
  @IBOutlet private weak var notesSwitch: UISwitch!
  @IBOutlet private weak var disturbanceSwitch: UISwitch!
  @IBOutlet private weak var messageTitleLabel: UILabel!
  @IBOutlet private weak var messageTextView: UITextView!

  var viewModel: ReportCenterViewModel!

  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    stabilizationSwitch.superview?.addBorder(toSide: .bottom, withColor: UIColor.color(withHexString: "#808080").cgColor, andThickness: 0.2)
    spectatorSwitch.superview?.addBorder(toSide: .bottom, withColor: UIColor.color(withHexString: "#808080").cgColor, andThickness: 0.2)
    notesSwitch.superview?.addBorder(toSide: .bottom, withColor: UIColor.color(withHexString: "#808080").cgColor, andThickness: 0.2)
    disturbanceSwitch.superview?.addBorder(toSide: .bottom, withColor: UIColor.color(withHexString: "#808080").cgColor, andThickness: 0.2)
    messageTextView.layer.borderColor = UIColor.color(withHexString: "#808080").cgColor
    messageTextView.layer.borderWidth = 0.2
    messageTextView.layer.cornerRadius = 4.0
  }

  override func viewDidLoad() {
        super.viewDidLoad()
    _ = NotificationCenter.default.addObserver(forName: UIResponder.keyboardDidShowNotification, object: nil, queue: nil, using: { (notification) in
      if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
        let keyboardRectangle = keyboardFrame.cgRectValue
        let keyboardHeight = keyboardRectangle.height
        self.scrollView.frame.size.height = self.view.bounds.height - (keyboardHeight / 2.0)
      }
    })

    _ = NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillHideNotification, object: nil, queue: nil, using: { (notification) in
      self.scrollView.frame.size.height = self.view.bounds.height
    })
        // Do any additional setup after loading the view.
    }
  @IBAction private func sendMessage(_ sender: Any) {
    messageTextView.resignFirstResponder()
    self.viewModel.sendReportMessage()
  }

}
