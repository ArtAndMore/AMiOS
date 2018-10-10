//
//  RegionViewController.swift
//  iVote
//
//  Created by Hasan Sa on 09/10/2018.
//  Copyright © 2018 Hasan Sa. All rights reserved.
//

import UIKit
import SwiftyPickerPopover

class RegionViewController: UIViewController {

  @IBOutlet private weak var pickerView: UIPickerView!
  @IBOutlet private weak var confirmButton: UIButton!

  var viewModel: RegionViewModel!
  
  var sites: [Site] = [] {
    didSet {
      self.pickerView.reloadAllComponents()
    }
  }
  override func viewDidLoad() {
    super.viewDidLoad()

    viewModel.sites.observe {
      self.sites = $0
    }

    viewModel.errorMessage.observe { (_) in
      self.confirmButton.shake()
    }
  }

  @IBAction func selectRegion() {
    self.viewModel.submit()
  }

}

extension RegionViewController: UIPickerViewDataSource {
  func numberOfComponents(in pickerView: UIPickerView) -> Int {
    return 1
  }

  func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
    return sites.count
  }
}

extension RegionViewController: UIPickerViewDelegate {
  func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
    let item = sites[row]
    return item.name
  }

  func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
    guard row < sites.count else {
      return
    }
    let item = sites[row]
    self.viewModel.path = item.path
  }

  func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
    return 60
  }
}
