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

  @IBOutlet fileprivate weak var loginButton: UIButton!
  @IBOutlet fileprivate var usernameTextField: UITextField!
  @IBOutlet fileprivate var passwordTextField: UITextField!
  @IBOutlet fileprivate var phoneNumberTextField: UITextField!

  var viewModel: AuthenticateViewModel! {
    didSet {
      viewModel.viewDelegate = self
    }
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    _ = NotificationCenter.default.addObserver(forName: UITextField.textDidChangeNotification, object: nil, queue: nil) { [weak self] (notification) in
      self?.textFieldDidChange(notification.object as? UITextField)
    }

    self.navigationController?.setNavigationBarHidden(false, animated: true)
    self.viewModel.errorMessage.observe { _ in
      self.loginButton.shake()
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
    guard let usernameText = usernameTextField.text,
     let passwordText = passwordTextField.text,
     let phoneNumberText = phoneNumberTextField.text else {
      return false
    }
    return !usernameText.isEmpty && !passwordText.isEmpty && !phoneNumberText.isEmpty
  }
}
