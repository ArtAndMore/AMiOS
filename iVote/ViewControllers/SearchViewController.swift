//
//  SearchViewController.swift
//  iVote
//
//  Created by Hasan Sa on 06/10/2018.
//  Copyright © 2018 Hasan Sa. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController {

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
  }

  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    textField.superview?.addBorder(toSide: .bottom, withColor: UIColor.color(withHexString: "#808080").cgColor, andThickness: 0.2)
  }

  @IBAction private func searchAction() {
    self.textField.resignFirstResponder()
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
  func searchViewModel(didFindVoters voters: [Voter]) {
    if let voter = voters.first {
      setupMatrixView()
      labelsMatrixView.addRecord(record: ["הצביע", "מס בקלפי", "קלפי", "שם", "תעודת זהות"])
      labelsMatrixView.addRecord(record: [voter.id, voter.firstName!, String(voter.ballotId!), String(voter.ballotNumber!), String(voter.hasVoted)].reversed())
    }
  }


}

extension SearchViewController: NALLabelsMatrixViewDelegate {
  func labelsMatrixView(_ labelsMatrixView: NALLabelsMatrixView, didSelectRowAt row: Int) {
    if let voterVC = self.storyboard?.instantiateViewController(withIdentifier: "VoterDetailsTableViewController") as? VoterDetailsTableViewController {
      voterVC.voter = self.viewModel.voters.first
      self.navigationController?.pushViewController(voterVC, animated: true)
    }
  }
}
