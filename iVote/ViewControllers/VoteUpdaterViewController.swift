//
//  VoteUpdaterViewController.swift
//  iVote
//
//  Created by Hasan Sa on 06/10/2018.
//  Copyright © 2018 Hasan Sa. All rights reserved.
//

import UIKit
import AlertBar

class VoteUpdaterViewController: UITableViewController {

  @IBOutlet fileprivate weak var updateVoteButton: UIButton!
  @IBOutlet fileprivate var ballotIdTextField: UITextField!
  @IBOutlet fileprivate var ballotNumberTextField: UITextField!

  var viewModel: VoteUpdaterViewModel! {
    didSet {
      viewModel.viewDelegate = self
    }
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    _ = NotificationCenter.default.addObserver(forName: UITextField.textDidChangeNotification, object: nil, queue: nil) { [weak self] (notification) in
      self?.textFieldDidChange(notification.object as? UITextField)
    }

    self.viewModel.errorMessage.observe { _ in
      self.updateVoteButton.shake()
    }
  }

  @IBAction private func updateVote() {
    self.viewModel.submit()
  }

}

private extension VoteUpdaterViewController {
  func textFieldDidChange(_ textField: UITextField?) {
    guard let textField = textField else {
      return
    }
    switch textField.tag {
    case 0:
      if let ballotId = textField.text {
        self.viewModel.ballotId = ballotId
      }
    case 1:
      if let ballotNumber = textField.text {
        self.viewModel.ballotNumber = ballotNumber
      }
    default:
      break;
    }
  }
}

extension VoteUpdaterViewController: UITextFieldDelegate {

  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    switch textField.tag {
    case 0:
      textFieldDidChange(textField)
      self.ballotNumberTextField.becomeFirstResponder()
    case 1:
      textField.resignFirstResponder()
      textFieldDidChange(textField)
      self.viewModel.submit()
    default:
      break;
    }
    return true
  }
}

extension VoteUpdaterViewController: VoteUpdaterViewModelDelegate {

  func canSubmit() -> Bool {
    ballotIdTextField.resignFirstResponder()
    ballotNumberTextField.resignFirstResponder()
    guard let ballotIdText = ballotIdTextField.text, let ballotNumberText = ballotNumberTextField.text else {
        return false
    }
    return !ballotIdText.isEmpty && !ballotNumberText.isEmpty
  }

  func voteUpdaterViewModel(didUpdateVoter success: Bool) {
    if success {
      AlertBar.show(type: .success, message: "עודכן בהצלחה")
    }
  }
}
