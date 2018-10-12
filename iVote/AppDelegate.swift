//
//  AppDelegate.swift
//  iVote
//
//  Created by Hasan Sa on 02/10/2018.
//  Copyright © 2018 Hasan Sa. All rights reserved.
//

import UIKit
import AlertBar

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

  var window: UIWindow?
  var appCoordinator: AppCoordinator?

  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    //
    Theme.configure()
    //
    self.observeReachabilityChanges()
    //
    DataController.configure()
    //
    window = UIWindow()
    appCoordinator = AppCoordinator(window: window!)
    appCoordinator?.start()
    window?.makeKeyAndVisible()

    return true
  }

  func applicationWillResignActive(_ application: UIApplication) {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
  }

  func applicationDidEnterBackground(_ application: UIApplication) {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
  }

  func applicationWillEnterForeground(_ application: UIApplication) {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
  }

  func applicationDidBecomeActive(_ application: UIApplication) {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
  }

  func applicationWillTerminate(_ application: UIApplication) {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
  }

}

private extension AppDelegate {

  func observeReachabilityChanges() {
    NotificationCenter.default.addObserver(forName: NSNotification.Name.ReachabilityIsUnreachable, object: nil, queue: OperationQueue.main) { (_) in
      AlertBar.show(type: .error, message: "אין חיבור אינטרנט")
    }
    NotificationCenter.default.addObserver(forName: NSNotification.Name.ReachabilityIsReachable, object: nil, queue: OperationQueue.main) { (_) in
      self.networkReachabilityHandler()
    }
  }

  func networkReachabilityHandler() {
    let voters = DataController.shared.fetchVoters()
    if !voters.isEmpty {
      self.updateVoters(voters)
    }
    let nominees = DataController.shared.fetchNominees()
    if !nominees.isEmpty {
      self.updateNominees(nominees)
    }
  }

  func updateVoters(_ voters: [Voter]) {
    voters.forEach { (voter) in
      if let ballotId = voter.ballotId, let ballotNumber = voter.ballotNumber {
        ElectionsService.shared.updateVoter(withBallotId: ballotId, ballotNumber: ballotNumber, completion: { (error) in
          if error == nil {
            DataController.shared.emptyVoter(voter)
          }
        })
      }
    }
  }

  func updateNominees(_ nominees: [Nominee]) {
    nominees.forEach { (nominee) in
      ElectionsService.shared.updateNominee(nominee, completion: { (error) in
        if error == nil {
          DataController.shared.emptyNominee(nominee)
        }
      })
    }

  }
}

