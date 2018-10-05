//
//  LoginViewController.swift
//  iVote
//
//  Created by Hasan Sa on 05/10/2018.
//  Copyright © 2018 Hasan Sa. All rights reserved.
//

import UIKit

protocol NavigationViewControllerCoordinatorDelegate: Coordinator {
  func showCode()
}

class LoginViewController: UIViewController {

  weak var coordinatorDelegate: NavigationViewControllerCoordinatorDelegate?

  private var formTableViewController: UserFormTableViewController?

  override func viewDidLoad() {
    super.viewDidLoad()
  }

  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

    if segue.identifier == "FormTableViewController" {
      if let formTableViewController = segue.destination as? UserFormTableViewController {
        self.formTableViewController = formTableViewController
        self.formTableViewController?.delegate = self
      }
    }
  }

  @IBAction func submitAction() {
    if let formTableViewController = self.formTableViewController,
      !formTableViewController.isEmptyForm() {
      // TODO: invoke request via ViewModel
      ElectionsService.shared.authenticate(user: formTableViewController.user) { (success) in
        if success {
          DispatchQueue.main.async {
            self.coordinatorDelegate?.showCode()
          }
        } else {
          print("authenticate failed")
        }
      }
    }
  }

}

extension LoginViewController: FormTableViewControllerDelegate {
  func formDidEndEditing() {
    submitAction()
  }
}
