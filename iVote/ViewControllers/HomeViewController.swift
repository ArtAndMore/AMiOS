//
//  HomeViewController.swift
//  iVote
//
//  Created by Hasan Sa on 02/10/2018.
//  Copyright © 2018 Hasan Sa. All rights reserved.
//

import UIKit

protocol HomeViewControllerCoordinatorDelegate: Coordinator {

}

class HomeViewController: UIViewController {

  weak var coordinatorDelegate: HomeViewControllerCoordinatorDelegate?

  struct ReusableCellIdentifiers {
    static let base         = "BallotCollectionViewCell"
    static let search       = "BallotSearchCollectionViewCell"
    static let status       = "BallotStatusCollectionViewCell"
    static let statistics   = "BallotStatisticsCollectionViewCell"
  }
  
  struct Item {
    let title: String
    let image: String
    let backgroundColor: UIColor
  }
  
  let page = [0:[""],
              1:[""],
              2:[""],
              3:[Item(title: "סטטוס קלפיות",
                      image: "vote",
                      backgroundColor: UIColor.color(withHexString: "#33D09D")),
                 Item(title: "עדכון הצבעה",
                      image: "voteBox",
                      backgroundColor: UIColor.color(withHexString: "#FB7572")),
                 Item(title: "ספירה",
                      image: "ranking",
                      backgroundColor: UIColor.color(withHexString: "#0199DA")),
                 Item(title: "דיווחים",
                      image: "coordination",
                      backgroundColor: UIColor.color(withHexString: "#5C86B8"))]]
  
  @IBOutlet fileprivate weak var collectionView: UICollectionView!
  
  override func viewDidLoad() {
        super.viewDidLoad()
    self.collectionView.register(BallotCollectionViewCell.nib(), forCellWithReuseIdentifier: ReusableCellIdentifiers.base)
    self.collectionView.register(BallotStatusCollectionViewCell.nib(), forCellWithReuseIdentifier: ReusableCellIdentifiers.status)
    self.collectionView.register(BallotStatisticsCollectionViewCell.nib(), forCellWithReuseIdentifier: ReusableCellIdentifiers.statistics)
    self.collectionView.register(BallotSearchCollectionViewCell.nib(), forCellWithReuseIdentifier: ReusableCellIdentifiers.search)
    }
}

extension HomeViewController: UICollectionViewDataSource {
  
  func numberOfSections(in collectionView: UICollectionView) -> Int {
    return page.count
  }
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return page[section]?.count ?? 0
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    var cell: UICollectionViewCell!
    switch indexPath.section {
    case 0:
      cell = collectionView.dequeueReusableCell(withReuseIdentifier: ReusableCellIdentifiers.status, for: indexPath)
    case 1:
      cell = collectionView.dequeueReusableCell(withReuseIdentifier: ReusableCellIdentifiers.statistics, for: indexPath)
    case 2:
      cell = collectionView.dequeueReusableCell(withReuseIdentifier: ReusableCellIdentifiers.search, for: indexPath)
    default:
      if let cellItem = collectionView.dequeueReusableCell(withReuseIdentifier: ReusableCellIdentifiers.base, for: indexPath) as? BallotCollectionViewCell , let item = page[indexPath.section]?[indexPath.row] as? Item {
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
    print(indexPath.section, indexPath.row)
  }
}

extension HomeViewController: UICollectionViewDelegateFlowLayout {
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    var size: CGSize = CGSize(width: collectionView.bounds.width - 10, height: 0)
    switch indexPath.section {
    case 0:
      size.height = 93.0
    case 1:
      size.height = 140.0
    case 2:
      size.height = 150.0
    default:
      size.width = (size.width - (collectionViewLayout as! UICollectionViewFlowLayout).minimumLineSpacing) * 0.5
      size.height = 110.0
    }
    return size
  }
}
