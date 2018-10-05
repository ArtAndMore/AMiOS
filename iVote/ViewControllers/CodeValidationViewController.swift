//
//  CodeValidationViewController.swift
//  iVote
//
//  Created by Hasan Sa on 05/10/2018.
//  Copyright © 2018 Hasan Sa. All rights reserved.
//

import UIKit
import SVPinView

protocol CodeValidationViewControllerCoordinatorDelegate: Coordinator {
  func showHome()
}

class CodeValidationViewController: UIViewController {

  weak var coordinatorDelegate: CodeValidationViewControllerCoordinatorDelegate?
  private var requestCode: String?

  @IBOutlet private weak var pinView: SVPinView! {
    didSet {
      pinView.pinLength = 4
      pinView.interSpace = 10
      pinView.textColor = UIColor.black
      pinView.borderLineColor = UIColor.color(withHexString: "#808080")
      pinView.borderLineThickness = 1
      pinView.shouldSecureText = false
      pinView.style = .underline
    }
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    ElectionsService.shared.getCode() { self.requestCode = $0 }
  }

  @IBAction func submitCodeAction() {
    guard let requestCode = self.requestCode else {
      print("request code failed")
      return
    }
    if requestCode == self.pinView.getPin() {
      self.coordinatorDelegate?.showHome()
    }
  }
}

