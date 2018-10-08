//
//  ElectionsService.swift
//  iVote
//
//  Created by Hasan Sa on 25/08/2018.
//  Copyright © 2018 Hasan Sa. All rights reserved.
//

import Foundation

/// <#Description#>
class ElectionsService: WebService {
  static let shared = ElectionsService()

  private var user: User?

  var isAuthenticated: Bool {
    get {
      return UserDefaults.standard.bool(forKey: "isLoggedIn")
    }
    set {
      UserDefaults.standard.set(newValue, forKey: "isLoggedIn")
    }
  }
  // MARK: - API

  // USER

  /// <#Description#>
  ///
  /// - Parameters:
  ///   - user: <#user description#>
  ///   - completion: <#completion description#>
  func authenticate(user: User, completion:((_ success: Bool) -> Void)? = nil) {
    self.queue.async {
      self.user = user
      let endPoint = EndPoints.UserAuthentication(user: self.user!)

      self.loadXMLAccessor(resource: endPoint.resource) { (xmlAccessor, error) in
        guard error == nil, let xml = xmlAccessor else {
          completion?(false)
          return
        }
        //        let errorMessage =
        if xml["User_AuthenticationResponse",
               "User_AuthenticationResult",
               "User",
               "User_phone"].text != nil {
          completion?(true)
        } else {
          completion?(false)
        }
      }
    }
  }


  /// <#Description#>
  ///
  /// - Parameter completion: <#completion description#>
  func getCode(completion:@escaping ((_ code: String?) -> Void)) {
    self.queue.async {
      guard let user = self.user else {
        completion(nil)
        return
      }
      let endPoint = EndPoints.UserSendCode(user: user)

      self.loadXMLAccessor(resource: endPoint.resource) { (xmlAccessor, error) in
        guard error == nil, let xml = xmlAccessor else {
          completion(nil)
          return
        }
        if let code = xml["User_Send_codeResponse",
                          "User_Send_codeResult",
                          "User_code"].text {
          completion(code)
        } else {
          completion(nil)
        }
      }
    }
  }

  // STATUS

  func status(ballotNumber: Int, completion:@escaping ((_ status: Status?) -> Void)) {
    self.queue.async {
      let endPoint = EndPoints.GetMainPageData(ballotNumber: ballotNumber)

      self.loadXMLAccessor(resource: endPoint.resource) { (xmlAccessor, error) in
        guard error == nil, let xml = xmlAccessor else {
          completion(nil)
          return
        }
        let statusData = xml["Get_MainPage_dataResponse", "Get_MainPage_dataResult"]
        // load ballot staus
        let ballotStatus = BallotStatus()
        ballotStatus.total = statusData["total_ballot_box"].text
        ballotStatus.isVoted = statusData["Isvote_ballot_box"].text
        ballotStatus.notVoted = statusData["Notevote_ballot_box"].text
        ballotStatus.votingPercentage = statusData["pr_ballot_box"].text
        // total data
        let votersStatus = VotersStatus()
        votersStatus.total = statusData["total_ballot_box"].text
        votersStatus.isVoted = statusData["Isvote_ballot_box"].text
        votersStatus.notVoted = statusData["Notevote_ballot_box"].text
        votersStatus.votingPercentage = statusData["pr_ballot_box"].text

        let status = Status(ballot: ballotStatus, voters: votersStatus)
        completion(status)
      }

    }
  }

  // VOTER

  func searchVoter(byId voterId: String, completion:@escaping ((_ voter: Voter?) -> Void)) {
    self.queue.async {
      let endPoint = EndPoints.SearchContactById(id: voterId)

      self.loadXMLAccessor(resource: endPoint.resource) { (xmlAccessor, error) in
        guard error == nil, let xml = xmlAccessor else {
          completion(nil)
          return
        }
        let contact = xml["Search_contact_by_idResponse",
                          "Search_contact_by_idResult",
                          "Search_contact"]
        guard let id = contact["Contact_id"].text,
          let fname = contact["Contact_fname"].text,
        let lname = contact["Contact_lname"].text,
        let father = contact["Contact_father_name"].text,
        let ballotId = contact["Contact_kalpi_id"].text,
        let ballotNumber = contact["Contact_kalpi_sidori_num"].text else {
          completion(nil)
          return
        }
        let voter = Voter(id: id)
        voter.firstName = fname
        voter.lastName = lname
        voter.fatherName = father
        voter.motherName = contact["Contact_mother_name"].text
        voter.grandFatherName = contact["Contact_grandfather_name"].text
        voter.address = contact["Contact_address"].text
        voter.hasVoted =  contact["Contact_isvoted"].text
        voter.ballotId = ballotId
        voter.ballotNumber = ballotNumber
        voter.phoneNumber = contact["Contact_phone"].text

        completion(voter)
      }

    }
  }

  func updateVoter(withBallotId ballotId: String, ballotNumber: String, completion:@escaping ((_ success: Bool) -> Void)) {
    self.queue.async {
      let endPoint = EndPoints.UpdateVote(ballotId: ballotId, ballotNumber: ballotNumber)
      self.loadXMLAccessor(resource: endPoint.resource) { (xmlAccessor, error) in
        guard error == nil, let xml = xmlAccessor else {
          completion(false)
          return
        }
        var success = false
        if let _ = xml["Update_voteResponse",
                          "Update_voteResult",
                          "Update_vote"].text {
          success = true
        }
        completion(success)
      }
    }
  }

  // NOMINEE

  func getAllNominee(completion:@escaping (([Nominee]) -> Void)) {
    self.queue.async {
      let endPoint = EndPoints.GetAllNominee()

      self.loadXMLAccessor(resource: endPoint.resource) { (xmlAccessor, error) in
        var nominees: [Nominee] = []
        guard error == nil, let xml = xmlAccessor else {
          completion(nominees)
          return
        }
        let elements = xml["get_all_NomineeResponse",
                           "get_all_NomineeResult",
                           "Get_all_Nominee",
                           "Nominee"]
        let iterator = elements.makeIterator()
        while let next = iterator.next() {
          let nominee = Nominee()
          if let name = next["Nominee_new_name"].text,
            let id = next["Nominee_new_id"].text {
            nominee.name = name
            nominee.id = id
            nominees.append(nominee)
          }
        }
        completion(nominees)
      }
    }
  }

  func updateNominee(_ nominee: Nominee, inBallotId ballotId: String, completion:@escaping ((_ success: Bool) -> Void)) {
    self.queue.async {
      let endPoint = EndPoints.CountVote(ballotId: ballotId,
                                         electedId: nominee.id,
                                         value: "\(nominee.status)")
      self.loadXMLAccessor(resource: endPoint.resource) { (xmlAccessor, error) in
        guard error == nil, let xml = xmlAccessor else {
          completion(false)
          return
        }
        var success = false
        if let _ = xml["Count_voteResponse",
                       "Count_voteResult",
                       "Count_vote"].text {
          success = true
        }
        completion(success)
      }
    }
  }

  // BALLOTS
  func getAllBallots(completion:@escaping ((_ success: [Ballot]) -> Void)) {
    self.queue.async {
      let endPoint = EndPoints.GetAllBallotBox()

      self.loadXMLAccessor(resource: endPoint.resource) { (xmlAccessor, error) in
        var ballots: [Ballot] = []
        guard error == nil, let xml = xmlAccessor else {
          completion(ballots)
          return
        }
        let elements = xml["Get_all_ballot_boxResponse",
                           "Get_all_ballot_boxResult",
                           "Get_all_ballot_box",
                           "Kalpi_status"]
        let iterator = elements.makeIterator()
        while let next = iterator.next() {
          guard let id = next["Kalpi_id"].text,
            let number = next["Kalpi_num"].text,
            let name = next["Kalpi_name"].text,
            let total = next["Total_in_kalpi"].text,
            let isVoted = next["IsVote"].text,
            let notVoted = next["NotVote"].text else {
              continue
          }

          let ballot = Ballot(id: id, number: number, name: name, total: total, isVoted: isVoted, notVoted: notVoted)
          ballots.append(ballot)
        }
        completion(ballots)
      }
    }
  }


  
}
