//
//  HomeViewController.swift
//  iVote
//
//  Created by Hasan Sa on 02/10/2018.
//  Copyright © 2018 Hasan Sa. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {

  struct ReusableCellIdentifiers {
    static let base         = "BallotCollectionViewCell"
    static let search       = "BallotSearchCollectionViewCell"
    static let statistics   = "BallotStatisticsCollectionViewCell"
  }
  
  var viewModel: HomeViewModel! {
    didSet {
      viewModel.viewDelegate = self
    }
  }
  
  @IBOutlet fileprivate weak var collectionView: UICollectionView!
  
  override func viewDidLoad() {
        super.viewDidLoad()
    self.collectionView.register(BallotCollectionViewCell.nib(), forCellWithReuseIdentifier: ReusableCellIdentifiers.base)
    self.collectionView.register(BallotStatisticsCollectionViewCell.nib(), forCellWithReuseIdentifier: ReusableCellIdentifiers.statistics)
    self.collectionView.register(BallotSearchCollectionViewCell.nib(), forCellWithReuseIdentifier: ReusableCellIdentifiers.search)
    }
}

private extension HomeViewController {
  @IBAction func logoutAction(_ sender: Any) {
    self.viewModel.logout()
  }

}


extension HomeViewController: UICollectionViewDataSource {
  
  func numberOfSections(in collectionView: UICollectionView) -> Int {
    return viewModel.numberOfSections
  }
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    switch section {
    case 0, 1:
      return 1
    case 2:
      return viewModel.items.count
    default:
      return 0
    }
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    var cell: UICollectionViewCell!
    switch indexPath.section {
    case 0:
      let statusCell = collectionView.dequeueReusableCell(withReuseIdentifier: ReusableCellIdentifiers.statistics, for: indexPath) as! BallotStatisticsCollectionViewCell
      statusCell.setStatus(self.viewModel.status)
      cell = statusCell
    case 1:
      cell = collectionView.dequeueReusableCell(withReuseIdentifier: ReusableCellIdentifiers.search, for: indexPath)
    default:
      if let itemCell = collectionView.dequeueReusableCell(withReuseIdentifier: ReusableCellIdentifiers.base, for: indexPath) as? BallotCollectionViewCell {
        let item = viewModel.items[indexPath.row]
        itemCell.set(item: item)
        cell = itemCell
      }
    }
    return cell
  }
}

extension HomeViewController: UICollectionViewDelegate {
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    switch indexPath.section {
    case 0: break
    case 1:
      self.viewModel.showSearch()
    case 2:
      switch indexPath.row {
      case 0:
        self.viewModel.showNomineeCounting()
      case 1:
        self.viewModel.showVote()
      case 2:
        self.viewModel.showBallotsStatus()
      case 3:
        self.viewModel.showReportCenter()
      default: break
      }
    default: break
    }
  }
}

extension HomeViewController: UICollectionViewDelegateFlowLayout {
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    var size: CGSize = CGSize(width: collectionView.bounds.width, height: 0)
    switch indexPath.section {
    case 0:
      size.height = collectionView.bounds.height * 0.3
    case 1:
      size.height = collectionView.bounds.height * 0.195
    default:
      size.width = (size.width - (collectionViewLayout as! UICollectionViewFlowLayout).minimumLineSpacing) * 0.5
      size.height = collectionView.bounds.height * 0.195
    }
    return size
  }
}

extension HomeViewController: HomeViewModelViewDelegate {
  func homeViewModel(didLoadStatus success: Bool) {
    if success {
      let indexPath = IndexPath(item: 0, section: 0)
      self.collectionView.reloadItems(at: [indexPath])
    }
  }


}
