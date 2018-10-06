//
//  LoginViewController.swift
//  iVote
//
//  Created by Hasan Sa on 05/10/2018.
//  Copyright © 2018 Hasan Sa. All rights reserved.
//

import UIKit

protocol LoginViewControllerCoordinatorDelegate: Coordinator {
  func authenticateViewModelDidLogin()
}

class LoginViewController: UIViewController {

  @IBOutlet fileprivate var usernameTextField: UITextField!
  @IBOutlet fileprivate var passwordTextField: UITextField!
  @IBOutlet fileprivate var phoneNumberTextField: UITextField!

  var viewModel: AuthenticateViewModel! {
    didSet {
      viewModel.viewDelegate = self
    }
  }

  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    usernameTextField.superview?.addBorder(toSide: .bottom, withColor: UIColor.color(withHexString: "#808080").cgColor, andThickness: 0.2)
    passwordTextField.superview?.addBorder(toSide: .bottom, withColor: UIColor.color(withHexString: "#808080").cgColor, andThickness: 0.2)
    phoneNumberTextField.superview?.addBorder(toSide: .bottom, withColor: UIColor.color(withHexString: "#808080").cgColor, andThickness: 0.2)
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    _ = NotificationCenter.default.addObserver(forName: UITextField.textDidChangeNotification, object: nil, queue: nil) { [weak self] (notification) in
      self?.textFieldDidChange(notification.object as? UITextField)
    }
  }
}

private extension LoginViewController {

  @IBAction func submitAction() {
    self.viewModel.submit()
  }

  func textFieldDidChange(_ textField: UITextField?) {
    guard let textField = textField else {
      return
    }
    switch textField.tag {
    case 0:
      if let text = textField.text {
        self.viewModel.user.name = text
      }
    case 1:
      if let password = textField.text {
        self.viewModel.user.password = password
      }
    case 2:
      if let phone = textField.text {
        self.viewModel.user.phone = phone
      }
    default:
      break;
    }
  }
}

extension LoginViewController: UITextFieldDelegate {

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
      self.viewModel.submit()
    default:
      break;
    }
    return true
  }
}

extension LoginViewController: AuthenticateViewModelViewDelegate {
  func canSubmit() -> Bool {
    usernameTextField.resignFirstResponder()
    passwordTextField.resignFirstResponder()
    phoneNumberTextField.resignFirstResponder()

    return usernameTextField.text?.isEmpty ?? true ||
      passwordTextField.text?.isEmpty ?? true ||
      phoneNumberTextField.text?.isEmpty ?? true
  }
}
