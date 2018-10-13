//
//  ReportCenterViewController.swift
//  iVote
//
//  Created by Hasan Sa on 06/10/2018.
//  Copyright © 2018 Hasan Sa. All rights reserved.
//

import UIKit
import StatusAlert

class ReportCenterViewController: TableViewController {

  @IBOutlet private weak var sendMessageButton: UIButton!

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
    self.view.endEditing(true)
    self.viewModel.sendReport(message: messageTextView.text)
  }
}

extension ReportCenterViewController: ReportCenterViewModelDlelegate {

  func reportCenterViewModel(didUpdateStatus success:Bool) {
    showAlert(withStatus: .update)
  }
  func reportCenterViewModel(didSentMessage success:Bool) {
    showAlert(withStatus: .send)
    self.messageTextView.text = ""
  }


}
