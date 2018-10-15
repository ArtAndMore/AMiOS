//
//  HomeViewController.swift
//  iVote
//
//  Created by Hasan Sa on 02/10/2018.
//  Copyright © 2018 Hasan Sa. All rights reserved.
//

import UIKit
import SwiftyPickerPopover
import JTSplashView
import StatusAlert

class HomeViewController: UIViewController, UIAdaptivePresentationControllerDelegate {

  struct ReusableCellIdentifiers {
    static let base         = "BallotCollectionViewCell"
    static let search       = "BallotSearchCollectionViewCell"
    static let statistics   = "BallotStatisticsCollectionViewCell"
  }
  
  var viewModel: HomeViewModel!

  @IBOutlet fileprivate weak var collectionView: UICollectionView!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.collectionView.register(BallotCollectionViewCell.nib(), forCellWithReuseIdentifier: ReusableCellIdentifiers.base)
    self.collectionView.register(BallotStatisticsCollectionViewCell.nib(), forCellWithReuseIdentifier: ReusableCellIdentifiers.statistics)
    self.collectionView.register(BallotSearchCollectionViewCell.nib(), forCellWithReuseIdentifier: ReusableCellIdentifiers.search)

    if self.viewModel.permission.value == nil {
      JTSplashView.splashView(withBackgroundColor: .white, circleColor: UIColor.color(withHexString: "#6CBBFF"), circleSize: nil)

      DispatchQueue.main.asyncAfter(deadline: .now() + 10) {
        JTSplashView.finish()
      }
    }

    observeViewModelChanges()
  }
}

private extension HomeViewController {
  func observeViewModelChanges() {

    self.viewModel.permission.observe { permission in
      if let permission = permission {
        self.navigationItem.leftBarButtonItem?.isEnabled = permission.ballots.count > 0
        let title = permission.ballots.first?.name ?? ""
        self.navigationItem.leftBarButtonItem?.title = "קלפי מס: \(title)"

        JTSplashView.finishWithCompletion() {
          self.collectionView.reloadData()
        }
      }
    }
    //
    self.viewModel.status.observe { data in
      self.collectionView.reloadData()
    }
  }

  @IBAction func showDropDown(_ sender: UIBarButtonItem) {
    guard let permission = self.viewModel.permission.value,
      let ballots = permission?.ballots else {
        return
    }
    let titles = ballots.map({ "\($0.name) - \($0.number)" })
    let ballotsNumbers = ballots.map({ $0.number })
    let index = ballotsNumbers.firstIndex(where: { $0 == self.viewModel.currentBallot }) ?? 0

    let originView = sender.value(forKey: "view") as! UIView
    StringPickerPopover(title: "מס קלפי", choices: titles)
      .setSelectedRow(index)
      .setValueChange(action: { (_, index, _) in
      })
      .setDoneButton(action: { (_, index, _) in
        let title = ballotsNumbers[index]
        sender.title = "קלפי מס: \(title)"
        self.viewModel.currentBallot = ballots[index].id
      })
      .setCancelButton(action: { (_, _, _) in }
      )
      .appear(originView: originView, baseViewController: self)
  }

  func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
    return UIModalPresentationStyle.none
  }

  func adaptivePresentationStyle(for controller: UIPresentationController, traitCollection: UITraitCollection) -> UIModalPresentationStyle {
    return UIModalPresentationStyle.none
  }

  @IBAction func logoutAction(_ sender: Any) {
    let alert = UIAlertController(title: "אנא אשר התנתקות בבקשה", message: "", preferredStyle: .actionSheet)

    alert.addAction(UIAlertAction(title: "אישור", style: .destructive , handler:{ (UIAlertAction)in
      self.viewModel.logout()
    }))

    alert.addAction(UIAlertAction(title: "ביטול", style: .cancel, handler: nil))

    self.present(alert, animated: true, completion:nil)
  }

}


extension HomeViewController: UICollectionViewDataSource {
  
  func numberOfSections(in collectionView: UICollectionView) -> Int {
    return viewModel.items.keys.count
  }
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return viewModel.items[section]?.count ?? 0
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    var cell: UICollectionViewCell!
    let item = viewModel.items[indexPath.section]![indexPath.row]
    switch item.type {
    case .statistics:
      let statusCell = collectionView.dequeueReusableCell(withReuseIdentifier: ReusableCellIdentifiers.statistics, for: indexPath) as! BallotStatisticsCollectionViewCell
      if let status = self.viewModel.status.value {
        statusCell.setStatus(status)
      }
      cell = statusCell
    case .query:
      cell = collectionView.dequeueReusableCell(withReuseIdentifier: ReusableCellIdentifiers.search, for: indexPath)
    default:
      if let itemCell = collectionView.dequeueReusableCell(withReuseIdentifier: ReusableCellIdentifiers.base, for: indexPath) as? BallotCollectionViewCell {
        let item = viewModel.items[indexPath.section]![indexPath.row]
        itemCell.setItem(item)
        cell = itemCell
      }
    }
    return cell
  }
}

extension HomeViewController: UICollectionViewDelegate {
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    let item = viewModel.items[indexPath.section]![indexPath.row]
    switch item.type {
    case .statistics:
      break
    case .query:
      self.viewModel.showSearch()
    case .ranking:
      self.viewModel.showNomineeCounting()
    case .voting:
      self.viewModel.showVote()
    case .status:
      self.viewModel.showBallotsStatus()
    case .report:
      self.viewModel.showReportCenter()
    }
  }
}

extension HomeViewController: UICollectionViewDelegateFlowLayout {
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    var size: CGSize = CGSize(width: collectionView.bounds.width, height: 0)
    let item = viewModel.items[indexPath.section]![indexPath.row]
    switch item.type {
    case .statistics:
      size.height = collectionView.bounds.height * 0.3
    case .query:
      size.height = collectionView.bounds.height * 0.195
    default:
      size.width = (size.width - (collectionViewLayout as! UICollectionViewFlowLayout).minimumLineSpacing) * 0.5
      size.height = collectionView.bounds.height * 0.195
    }
    return size
  }
}
