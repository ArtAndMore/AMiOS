//
//  ElectionsService.swift
//  iVote
//
//  Created by Hasan Sa on 25/08/2018.
//  Copyright © 2018 Hasan Sa. All rights reserved.
//

import Foundation

class ElectionsService: WebService {
  static let shared = ElectionsService()

  var user: User = User()

  // MARK: - USER

  func authenticate(completion: @escaping ((_ success: Bool) -> Void)) {
    self.queue.async {
      let endPoint = EndPoints.UserAuthentication(user: self.user)

      self.loadXMLAccessor(resource: endPoint.resource) { (xmlAccessor, error) in
        guard error == nil, let xml = xmlAccessor else {
          completion(false)
          return
        }
        if xml["User_AuthenticationResponse",
               "User_AuthenticationResult",
               "User",
               "User_phone"].text != nil {
          completion(true)
        } else {
          completion(false)
        }
      }
    }
  }

  func getCode(completion:@escaping ((_ code: String?) -> Void)) {
    self.queue.async {
      let endPoint = EndPoints.UserSendCode(user: self.user)

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

  func permission(completion:@escaping ((_ permission: Permission?) -> Void)) {
    self.queue.async {
      let endPoint = EndPoints.UserPermission(user: self.user)

      self.loadXMLAccessor(resource: endPoint.resource) { (xmlAccessor, error) in

        guard error == nil, let xml = xmlAccessor else {
          completion(nil)
          return
        }
        let elements = xml["User_PermissionResponse",
                           "User_PermissionResult",
                           "User_Permission",
                           "kalpi"]
        var ballots: [Ballot] = []
        let iterator = elements.makeIterator()
        while let next = iterator.next() {
          guard let id = next["Kalpi_id"].text, let name = next["Kalpi_name"].text else {
              continue
          }

          let ballot = Ballot(id: id, number: id, name: name, total: "", isVoted: "", notVoted: "")
          ballot.address = next["Kalpi_address"].text
          if let stabilization = next["New_kalpi_st_hafraot"].text {
            ballot.reports[.stabilization] = Bool(stabilization)
          }
          if let spectator = next["New_mashkif"].text {
            ballot.reports[.stabilization] = Bool(spectator)
          }
          if let notes = next["New_ptakim_status"].text {
            ballot.reports[.stabilization] = Bool(notes)
          }
          if let disturbance = next["New_kalpi_st_htyasvot"].text {
            ballot.reports[.stabilization] = Bool(disturbance)
          }
          ballots.append(ballot)
        }
        self.user.permission.ballots = ballots
        completion(self.user.permission)
      }
    }
  }

  // MARK: - STATUS

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

  // MARK: - VOTER

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

  // MARK: - NOMINEE

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

  // MARK: - BALLOTS

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

  // MARK: - REPORT

  func updateReport(byType type: ReportType, status: Int, inBallotId ballotId: String, completion:@escaping ((_ success: Bool) -> Void)) {
    self.queue.async {
      var endPoint: EndPoint
      var responseKey: String
      switch type {
      case .stabilization:
        responseKey = "Update_Ballot_box_st_htyasvotResult"
        endPoint = EndPoints.UpdateBallotBoxStHtyasvot(ballotId: ballotId, status: "\(status)")
      case .spectator:
        responseKey = "Update_Ballot_box_st_mashkif"
        endPoint = EndPoints.UpdateBallotBoxStMashkif(ballotId: ballotId, status: "\(status)")
      case .notes:
        responseKey = "Update_Ballot_box_ptakim"
        endPoint = EndPoints.UpdateBallotBoxPtakim(ballotId: ballotId, status: "\(status)")
      case .disturbance:
        responseKey = "Update_Ballot_box_st_hafraot"
        endPoint = EndPoints.UpdateBallotBoxStHafraot(ballotId: ballotId, status: "\(status)")
      }

      self.loadXMLAccessor(resource: endPoint.resource) { (xmlAccessor, error) in
        guard error == nil, let xml = xmlAccessor else {
          completion(false)
          return
        }
        var success = false
        if let _ = xml["Update_Ballot_box_ptakimResponse",
                       "Update_Ballot_box_ptakimResult",
                       responseKey].text {
          success = true
        }
        completion(success)
      }
    }
  }

  func sendReportMessage(_ message: String, inBallotId ballotId: String, completion:@escaping ((_ success: Bool) -> Void)) {
    self.queue.async {
      let endPoint = EndPoints.SendMessgeToControl(username: self.user.name, message: message)
      self.loadXMLAccessor(resource: endPoint.resource) { (xmlAccessor, error) in
        guard error == nil, let xml = xmlAccessor else {
          completion(false)
          return
        }
        var success = false
        if let _ = xml["Send_msg_to_controlResponse",
                       "Send_msg_to_controlResult",
                       "Send_msg_to_control"].text {
          success = true
        }
        completion(success)
      }
    }
  }
  
}
