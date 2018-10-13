//
//  SearchViewController.swift
//  iVote
//
//  Created by Hasan Sa on 06/10/2018.
//  Copyright © 2018 Hasan Sa. All rights reserved.
//

import UIKit

class SearchViewController: TableViewController {

  @IBOutlet private weak var searchButton: UIButton!
  @IBOutlet private weak var resultsTableViewContainer: UIView!
  @IBOutlet private weak var textField: UITextField!
  @IBOutlet private var labelsMatrixView: NALLabelsMatrixView!

  var viewModel: SearchViewModel! {
    didSet {
      viewModel.viewDelegate = self
    }
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    viewModel.errorMessage.observe { (_) in
      self.searchButton.shake()
    }
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    if let text = textField.text, !text.isEmpty {
      self.searchAction()
    }
  }

  @IBAction private func searchAction() {
    self.view.endEditing(true)
    self.labelsMatrixView?.removeFromSuperview()
    self.viewModel.searchVoter(withId: self.textField.text)
  }
}


private extension SearchViewController {

  func setupMatrixView() {
    let width = resultsTableViewContainer.bounds.width
    self.labelsMatrixView = NALLabelsMatrixView(frame: resultsTableViewContainer.bounds,
                                                columns: [ Int(0.14 * width), Int(0.2 * width), Int(0.16 * width), Int(0.25 * width), Int(0.25 * width)])
    self.labelsMatrixView.delegate = self
    self.resultsTableViewContainer.addSubview(self.labelsMatrixView)
  }
}

extension SearchViewController: UITextFieldDelegate {

  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    self.searchAction()
    return true
  }
}

extension SearchViewController: SearchViewModelDelegate {
  func searchViewModel(didFindVoter voter: Voter) {
      setupMatrixView()
      labelsMatrixView.addRecord(record: ["הצביע", "מס בקלפי", "קלפי", "שם", "תעודת זהות"])
    let isVotedIcon = Bool(voter.hasVoted) ? "✅" : "⛔️"
    labelsMatrixView.addRecord(record: [voter.id, voter.firstName!, voter.ballotId!, voter.ballotNumber!, isVotedIcon].reversed())
  }


}

extension SearchViewController: NALLabelsMatrixViewDelegate {
  func labelsMatrixView(_ labelsMatrixView: NALLabelsMatrixView, didSelectRowAt row: Int) {
    self.viewModel.showVoterDetails()
  }
}
