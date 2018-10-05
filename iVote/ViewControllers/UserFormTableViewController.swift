//
//  FormTableViewController.swift
//  iVote
//
//  Created by Hasan Sa on 05/10/2018.
//  Copyright © 2018 Hasan Sa. All rights reserved.
//

import UIKit

protocol FormTableViewControllerDelegate: AnyObject {
  func formDidEndEditing()
}

class UserFormTableViewController: UITableViewController {

  weak var delegate:FormTableViewControllerDelegate?
  private(set) var user: User = User(name: "", password: "", phone: "")

  @IBOutlet fileprivate var usernameTextField: UITextField!
  @IBOutlet fileprivate var passwordTextField: UITextField!
  @IBOutlet fileprivate var phoneNumberTextField: UITextField!

  override func viewDidLoad() {
    super.viewDidLoad()
    _ = NotificationCenter.default.addObserver(forName: UITextField.textDidChangeNotification, object: nil, queue: nil) { [weak self] (notification) in
      self?.textFieldDidChange(notification.object as? UITextField)
    }
  }


  func isEmptyForm() -> Bool {
    return usernameTextField.text?.isEmpty ?? true ||
           passwordTextField.text?.isEmpty ?? true ||
           phoneNumberTextField.text?.isEmpty ?? true
  }

  // MARK: - Table view data source
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 3
  }

}

private extension UserFormTableViewController {
  func textFieldDidChange(_ textField: UITextField?) {
    guard let textField = textField else {
      return
    }
    switch textField.tag {
    case 0:
      if let text = textField.text {
        self.user.name = text
      }
    case 1:
      if let password = textField.text {
        self.user.password = password
      }
    case 2:
      if let phone = textField.text {
        self.user.phone = phone
      }
    default:
      break;
    }
  }
}

extension UserFormTableViewController: UITextFieldDelegate {

  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    switch textField.tag {
    case 0:
      textFieldDidChange(textField)
      self.passwordTextField.becomeFirstResponder()
    case 1:
      textFieldDidChange(textField)
      self.phoneNumberTextField.becomeFirstResponder()
    case 2:
      textField.resignFirstResponder()
      textFieldDidChange(textField)
      self.delegate?.formDidEndEditing()
    default:
      break;
    }
    return true
  }
}
