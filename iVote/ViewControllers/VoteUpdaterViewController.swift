//
//  VoteUpdaterViewController.swift
//  iVote
//
//  Created by Hasan Sa on 06/10/2018.
//  Copyright © 2018 Hasan Sa. All rights reserved.
//

import UIKit

class VoteUpdaterViewController: UIViewController {

  @IBOutlet fileprivate var ballotIdTextField: UITextField!
  @IBOutlet fileprivate var ballotNumberTextField: UITextField!

  var viewModel: VoteUpdaterViewModel! {
    didSet {
      viewModel.viewDelegate = self
    }
  }

  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    ballotIdTextField.superview?.addBorder(toSide: .bottom, withColor: UIColor.color(withHexString: "#808080").cgColor, andThickness: 0.2)
    ballotNumberTextField.superview?.addBorder(toSide: .bottom, withColor: UIColor.color(withHexString: "#808080").cgColor, andThickness: 0.2)
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    _ = NotificationCenter.default.addObserver(forName: UITextField.textDidChangeNotification, object: nil, queue: nil) { [weak self] (notification) in
      self?.textFieldDidChange(notification.object as? UITextField)
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
        self.viewModel.voter?.ballotId = Int(ballotId)
      }
    case 1:
      if let ballotNumber = textField.text {
        self.viewModel.voter?.ballotNumber = Int(ballotNumber)
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

    return ballotIdTextField.text?.isEmpty ?? true || ballotNumberTextField.text?.isEmpty ?? true
  }

  func voteUpdaterViewModel(didUpdateVoter success: Bool) {
    print("voter updated successfully")
  }
}
