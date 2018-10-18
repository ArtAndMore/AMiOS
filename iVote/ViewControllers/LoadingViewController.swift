//
//  LoadingViewController.swift
//  iVote
//
//  Created by Hasan Sa on 18/10/2018.
//  Copyright © 2018 Hasan Sa. All rights reserved.
//

import UIKit
import JTSplashView

class LoadingViewController: UIViewController {

  var viewModel: LoadingViewModel!

  override func viewDidLoad() {
    super.viewDidLoad()
    JTSplashView.splashView(withBackgroundColor: .white, circleColor: UIColor.color(withHexString: "#6CBBFF"), circleSize: nil)
  }

}
