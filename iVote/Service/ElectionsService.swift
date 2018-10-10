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
  var currentBallot: String =  ""
  // MARK: - GLOBAL SERVICES URLS

  func sites(completion: @escaping ((_ sites: [Site]) -> Void)) {
    var sites: [Site] = []
    let endPoint = EndPoints.Global()
    self.loadXMLAccessor(resource: endPoint.resource) { (xmlAccessor, error) in
      guard error == nil, let xml = xmlAccessor else {
        completion(sites)
        return
      }
      let responseData = xml["get_web_addResponse", "get_web_addResult"]
      guard let value = responseData["ContainsErrors"].text, Bool(value) == false else {
        completion(sites)
        return
      }
      let iterator = responseData["sites", "site"].makeIterator()

      while let next = iterator.next() {
        guard let id = next["Site_id"].text, let name = next["Site_name"].text, let path = next["Site_path"].text else {
          continue
        }
        let site = Site(name: name, id: id, path: path)
        sites.append(site)
      }
      completion(sites)
    }
  }

  // MARK: - USER

  func authenticate(completion: @escaping ((_ permission: Permission?) -> Void)) {
    self.queue.async {
      let endPoint = EndPoints.UserAuthentication(path: self.user.path, user: self.user)
      self.loadXMLAccessor(resource: endPoint.resource) { (xmlAccessor, error) in
        guard error == nil, let xml = xmlAccessor else {
          completion(nil)
          return
        }
        let responseData = xml["User_AuthenticationResponse",
                              "User_AuthenticationResult"]
        guard let value = responseData["ContainsErrors"].text, Bool(value) == false else {
          completion(nil)
          return
        }
        let userData = responseData["User"]

        let permission = Permission()
        permission.canQuery = Bool(userData["New_search"].text)
        permission.canUpdateVotes = Bool(userData["New_harsha_set_vote"].text)
        permission.canUpdateNomineeCount = Bool(userData["New_vote_count"].text)
        permission.canReadBallots = Bool(userData["New_kalpi_status"].text)
        permission.canReportIssue = Bool(userData["New_harshat_dovoh"].text)

        let ballotsData = responseData["User_Permission", "kalpi"]
        let iterator = ballotsData.makeIterator()
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
          permission.ballots.append(ballot)
        }
        self.currentBallot = permission.ballots.first?.id ?? ""
        self.user.permission = permission
        completion(permission)
      }
    }
  }

  func getCode(completion:@escaping ((_ code: String?) -> Void)) {
    self.queue.async {
      let endPoint = EndPoints.UserSendCode(path: self.user.path, user: self.user)

      self.loadXMLAccessor(resource: endPoint.resource) { (xmlAccessor, error) in
        guard error == nil, let xml = xmlAccessor else {
          completion(nil)
          return
        }
        let responseData = xml["User_Send_codeResponse", "User_Send_codeResult"]
        guard let value = responseData["ContainsErrors"].text, Bool(value) == false else {
          completion(nil)
          return
        }
        if let code = responseData["User_code"].text {
          completion(code)
        } else {
          completion(nil)
        }
      }
    }
  }

  // MARK: - STATUS

  func statusForCurrentBallot(completion:@escaping ((_ status: Status?) -> Void)) {
    self.queue.async {
      let endPoint = EndPoints.GetMainPageData(path: self.user.path, ballotNumber: self.currentBallot)

      self.loadXMLAccessor(resource: endPoint.resource) { (xmlAccessor, error) in
        guard error == nil, let xml = xmlAccessor else {
          completion(nil)
          return
        }
        let responseData = xml["Get_MainPage_dataResponse", "Get_MainPage_dataResult"]
        guard let value = responseData["ContainsErrors"].text, Bool(value) == false else {
          completion(nil)
          return
        }
        // load ballot staus
        let ballotStatus = BallotStatus()
        ballotStatus.total = responseData["total_ballot_box"].text
        ballotStatus.isVoted = responseData["Isvote_ballot_box"].text
        ballotStatus.notVoted = responseData["Notevote_ballot_box"].text
        ballotStatus.votingPercentage = responseData["pr_ballot_box"].text
        // total data
        let votersStatus = VotersStatus()
        votersStatus.total = responseData["total_ballot_box"].text
        votersStatus.isVoted = responseData["Isvote_ballot_box"].text
        votersStatus.notVoted = responseData["Notevote_ballot_box"].text
        votersStatus.votingPercentage = responseData["pr_ballot_box"].text

        let status = Status(ballot: ballotStatus, voters: votersStatus)
        completion(status)
      }

    }
  }

  // MARK: - VOTER

  func searchVoter(byId voterId: String, completion:@escaping ((_ voter: Voter?) -> Void)) {
    self.queue.async {
      let endPoint = EndPoints.SearchContactById(path: self.user.path, id: voterId)

      self.loadXMLAccessor(resource: endPoint.resource) { (xmlAccessor, error) in
        guard error == nil, let xml = xmlAccessor else {
          completion(nil)
          return
        }
        let responseData = xml["Search_contact_by_idResponse", "Search_contact_by_idResult"]

        guard let value = responseData["ContainsErrors"].text, Bool(value) == false else {
          completion(nil)
          return
        }
        let contact = responseData["Search_contact"]
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
      let endPoint = EndPoints.UpdateVote(path: self.user.path, ballotId: ballotId, ballotNumber: ballotNumber)
      self.loadXMLAccessor(resource: endPoint.resource) { (xmlAccessor, error) in
        guard error == nil, let xml = xmlAccessor else {
          completion(false)
          return
        }
        var success = false
        let responseData = xml["Update_voteResponse", "Update_voteResult"]

        guard let value = responseData["ContainsErrors"].text, Bool(value) == false else {
          completion(false)
          return
        }
        if let _ = xml["Update_vote"].text {
          success = true
        }
        completion(success)
      }
    }
  }

  // MARK: - NOMINEE

  func getAllNominee(completion:@escaping (([Nominee]) -> Void)) {
    self.queue.async {
      let endPoint = EndPoints.GetAllNominee(path: self.user.path)

      self.loadXMLAccessor(resource: endPoint.resource) { (xmlAccessor, error) in
        var nominees: [Nominee] = []
        guard error == nil, let xml = xmlAccessor else {
          completion(nominees)
          return
        }
        let responseData = xml["get_all_NomineeResponse", "get_all_NomineeResult"]
        guard let value = responseData["ContainsErrors"].text, Bool(value) == false else {
          completion(nominees)
          return
        }
        let elements = responseData["Get_all_Nominee", "Nominee"]
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

  func updateNominee(_ nominee: Nominee, completion:@escaping ((_ success: Bool) -> Void)) {
    self.queue.async {
      let endPoint = EndPoints.CountVote(path: self.user.path, ballotId: self.currentBallot,
                                         electedId: nominee.id,
                                         value: "\(nominee.status)")
      self.loadXMLAccessor(resource: endPoint.resource) { (xmlAccessor, error) in
        guard error == nil, let xml = xmlAccessor else {
          completion(false)
          return
        }
        var success = false
        let responseData = xml["Count_voteResponse", "Count_voteResult"]
        guard let value = responseData["ContainsErrors"].text, Bool(value) == false else {
          completion(false)
          return
        }
       if responseData["Count_vote"].text != nil {
          success = true
        }
        completion(success)
      }
    }
  }

  // MARK: - BALLOTS

  func getAllBallots(completion:@escaping ((_ success: [Ballot]) -> Void)) {
    self.queue.async {
      let endPoint = EndPoints.GetAllBallotBox(path: self.user.path)

      self.loadXMLAccessor(resource: endPoint.resource) { (xmlAccessor, error) in
        var ballots: [Ballot] = []
        guard error == nil, let xml = xmlAccessor else {
          completion(ballots)
          return
        }
        let responseData = xml["Get_all_ballot_boxResponse", "Get_all_ballot_boxResult"]
        guard let value = responseData["ContainsErrors"].text, Bool(value) == false else {
          completion(ballots)
          return
        }
        let elements = responseData["Get_all_ballot_box", "Kalpi_status"]
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

  func updateReport(byType type: ReportType, status: Int, completion:@escaping ((_ success: Bool) -> Void)) {
    self.queue.async {
      let ballotId = self.currentBallot
      var endPoint: EndPoint
      var responseKey: String
      switch type {
      case .stabilization:
        responseKey = "Update_Ballot_box_st_htyasvotResult"
        endPoint = EndPoints.UpdateBallotBoxStHtyasvot(path: self.user.path, ballotId: ballotId, status: "\(status)")
      case .spectator:
        responseKey = "Update_Ballot_box_st_mashkif"
        endPoint = EndPoints.UpdateBallotBoxStMashkif(path: self.user.path, ballotId: ballotId, status: "\(status)")
      case .notes:
        responseKey = "Update_Ballot_box_ptakim"
        endPoint = EndPoints.UpdateBallotBoxPtakim(path: self.user.path, ballotId: ballotId, status: "\(status)")
      case .disturbance:
        responseKey = "Update_Ballot_box_st_hafraot"
        endPoint = EndPoints.UpdateBallotBoxStHafraot(path: self.user.path, ballotId: ballotId, status: "\(status)")
      }

      self.loadXMLAccessor(resource: endPoint.resource) { (xmlAccessor, error) in
        guard error == nil, let xml = xmlAccessor else {
          completion(false)
          return
        }
        var success = false
        let responseData = xml["Update_Ballot_box_ptakimResponse", "Update_Ballot_box_ptakimResult"]
        guard let value = responseData["ContainsErrors"].text, Bool(value) == false else {
          completion(false)
          return
        }
        if responseData[responseKey].text != nil {
          success = true
        }
        completion(success)
      }
    }
  }

  func sendReportMessage(_ message: String, completion:@escaping ((_ success: Bool) -> Void)) {
    self.queue.async {
      let endPoint = EndPoints.SendMessgeToControl(path: self.user.path, username: self.user.name, message: message)
      self.loadXMLAccessor(resource: endPoint.resource) { (xmlAccessor, error) in
        guard error == nil, let xml = xmlAccessor else {
          completion(false)
          return
        }
        var success = false
        let responseData = xml["Send_msg_to_controlResponse", "Send_msg_to_controlResult"]
        guard let value = responseData["ContainsErrors"].text, Bool(value) == false else {
          completion(false)
          return
        }
        if responseData["Send_msg_to_control"].text != nil{
          success = true
        }
        completion(success)
      }
    }
  }
  
}
