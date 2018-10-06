//
//  CodeValidationViewController.swift
//  iVote
//
//  Created by Hasan Sa on 05/10/2018.
//  Copyright © 2018 Hasan Sa. All rights reserved.
//

import UIKit
import SVPinView

class CodeValidationViewController: UIViewController {

  private var requestCode: String?

  var viewModel: CodeValidationViewModel! {
    didSet {
      viewModel.viewDelegate = self
    }
  }

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
  }

  @IBAction func submitCodeAction() {
    self.viewModel.submit()
    
  }
}

extension CodeValidationViewController: CodeValidationViewModelViewDelegate {
  func pinCode() -> String {
    return self.pinView.getPin()
  }


}
