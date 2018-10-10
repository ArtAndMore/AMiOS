//
//  ReportCenterViewController.swift
//  iVote
//
//  Created by Hasan Sa on 06/10/2018.
//  Copyright © 2018 Hasan Sa. All rights reserved.
//

import UIKit

class ReportCenterViewController: UIViewController {

  @IBOutlet private weak var sendMessageButton: UIButton!
  @IBOutlet private weak var scrollView: UIScrollView!
  @IBOutlet private weak var stabilizationSwitch: UISwitch!
  @IBOutlet private weak var spectatorSwitch: UISwitch!
  @IBOutlet private weak var notesSwitch: UISwitch!
  @IBOutlet private weak var disturbanceSwitch: UISwitch!
  @IBOutlet private weak var messageTitleLabel: UILabel!
  
  @IBOutlet private weak var messageTextView: UITextView! {
    didSet {
      messageTextView.layer.borderColor = UIColor.color(withHexString: "#808080").cgColor
      messageTextView.layer.borderWidth = 0.2
      messageTextView.layer.cornerRadius = 4.0
    }
  }

  var viewModel: ReportCenterViewModel! {
    didSet {
      viewModel.viewDelegate = self
    }
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

    self.viewModel.errorMessage.observe { (_) in
      self.sendMessageButton.shake()
    }
  }

  @IBAction func switchValueChangeAction(_ sender: UISwitch) {
    if let type = ReportType(rawValue: sender.tag) {
      self.viewModel.sendReport(byType: type, status: Int(truncating: NSNumber(value: sender.isOn)))
    }
  }
  
  @IBAction private func sendMessage(_ sender: Any) {
    messageTextView.resignFirstResponder()
    self.viewModel.sendReport(message: messageTextView.text)
  }
}

extension ReportCenterViewController: ReportCenterViewModelDlelegate {
  func reportCenterViewModel(didSentMessage success: Bool) {
    self.messageTextView.text = ""
  }


}
