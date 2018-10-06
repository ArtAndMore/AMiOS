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
  
  var viewModel: HomeViewModel!
  
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
    return viewModel.page.count
  }
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return viewModel.page[section]?.count ?? 0
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    var cell: UICollectionViewCell!
    switch indexPath.section {
    case 0:
      cell = collectionView.dequeueReusableCell(withReuseIdentifier: ReusableCellIdentifiers.statistics, for: indexPath)
    case 1:
      cell = collectionView.dequeueReusableCell(withReuseIdentifier: ReusableCellIdentifiers.search, for: indexPath)
    default:
      if let cellItem = collectionView.dequeueReusableCell(withReuseIdentifier: ReusableCellIdentifiers.base, for: indexPath) as? BallotCollectionViewCell ,
        let item = viewModel.item(atIndexPath: indexPath) {
        cellItem.titleLabel.text = item.title
        cellItem.imageView.image = UIImage(named: item.image)
        cellItem.backgroundColor = item.backgroundColor
        cell = cellItem
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
