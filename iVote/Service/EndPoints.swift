//
//  EndPoints.swift
//  iVote
//
//  Created by Hasan Sa on 04/10/2018.
//  Copyright © 2018 Hasan Sa. All rights reserved.
//

import Foundation

struct EndPoints {

  struct Global: EndPoint {
    var soapMessage: String? {
      return """
      <soap:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/">
      <soap:Body>
      <get_web_add xmlns="http://tempuri.org/" />
      </soap:Body>
      </soap:Envelope>
      """
    }
  }

  struct CountVote: EndPoint {
    let path: String
    let ballotId: String
    let electedId: String
    let value: String

    var soapMessage: String? {
      return """
      <soap:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/">
      <soap:Body>
      <Count_vote xmlns="http://tempuri.org/">
      <kalpi_id>\(ballotId)</kalpi_id>
      <nevhar_id>\(electedId)</nevhar_id>
      <val>\(value)</val>
      </Count_vote>
      </soap:Body>
      </soap:Envelope>
      """
    }
  }

  struct GetMainPageData: EndPoint {
    let path: String
    let ballotNumber: String

    var soapMessage: String? {
      return """
      <soap:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/">
      <soap:Body>
      <Get_MainPage_data xmlns="http://tempuri.org/">
      <kalpinum>\(ballotNumber)</kalpinum>
      </Get_MainPage_data>
      </soap:Body>
      </soap:Envelope>
      """
    }
  }

  struct GetAllBallotBox: EndPoint {
    let path: String
    var soapMessage: String? {
      return """
      <soap:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/">
      <soap:Body>
      <Get_all_ballot_box xmlns="http://tempuri.org/">
      <code></code>
      </Get_all_ballot_box>
      </soap:Body>
      </soap:Envelope>
      """
    }
  }

  struct GetAllBallotBoxById: EndPoint {
    let path: String
    let ballotNumber: Int

    var soapMessage: String? {
      return """
      <soap:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/">
      <soap:Body>
      <Get_all_ballot_box_by_id xmlns="http://tempuri.org/">
      <kalpinum>\(ballotNumber)</kalpinum>
      </Get_all_ballot_box_by_id>
      </soap:Body>
      </soap:Envelope>
      """
    }
  }

  struct SearchContact: EndPoint {
    let path: String
    let voter: Voter

    var soapMessage: String? {
      return """
      <soap:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/">
      <soap:Body>
      <Search_contact xmlns="http://tempuri.org/">
      <contact_fname>\(String(describing: voter.firstName))</contact_fname>
      <contact_lname>\(String(describing: voter.lastName))</contact_lname>
      <contact_id>\(voter.id)</contact_id>
      <contact_father_name>\(String(describing: voter.fatherName))</contact_father_name>
      <isvote>\(voter.hasVoted.hashValue)</isvote>
      </Search_contact>
      </soap:Body>
      </soap:Envelope>
      """
    }
  }

  struct SearchContactById: EndPoint {
    let path: String
    let id: String
    var soapMessage: String? {
      return """
      <soap:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/">
      <soap:Body>
      <Search_contact_by_id xmlns="http://tempuri.org/">
      <contact_id>\(id)</contact_id>
      </Search_contact_by_id>
      </soap:Body>
      </soap:Envelope>
      """
    }
  }

  struct SendMessgeToControl: EndPoint {
    let path: String
    let username: String
    let message: String

    var soapMessage: String? {
      return """
      <soap:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/">
      <soap:Body>
      <Send_msg_to_control xmlns="http://tempuri.org/">
      <sub></sub>
      <msg>\(message)</msg>
      <user>\(username)</user>
      </Send_msg_to_control>
      </soap:Body>
      </soap:Envelope>
      """
    }
  }

  struct UpdateBallotBoxPtakim: EndPoint {
    let path: String
    let ballotId: String
    let status: String
    
    var soapMessage: String? {
      return """
      <soap:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/">
      <soap:Body>
      <Update_Ballot_box_ptakim xmlns="http://tempuri.org/">
      <kalpi_id>\(ballotId)</kalpi_id>
      <status>\(status)</status>
      </Update_Ballot_box_ptakim>
      </soap:Body>
      </soap:Envelope>
      """
    }
  }

  struct UpdateBallotBoxStHafraot: EndPoint {
    let path: String
    let ballotId: String
    let status: String
    
    var soapMessage: String? {
      return """
      <soap:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/">
      <soap:Body>
      <Update_Ballot_box_st_hafraot xmlns="http://tempuri.org/">
      <kalpi_id>\(ballotId)</kalpi_id>
      <status>\(status)</status>
      </Update_Ballot_box_st_hafraot>
      </soap:Body>
      </soap:Envelope>
      """
    }
  }

  struct UpdateBallotBoxStHtyasvot: EndPoint {
    let path: String
    let ballotId: String
    let status: String
    
    var soapMessage: String? {
      return """
      <soap:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/">
      <soap:Body>
      <Update_Ballot_box_st_htyasvot xmlns="http://tempuri.org/">
      <kalpi_id>\(ballotId)</kalpi_id>
      <status>\(status)</status>
      </Update_Ballot_box_st_htyasvot>
      </soap:Body>
      </soap:Envelope>
      """
    }
  }

  struct UpdateBallotBoxStMashkif: EndPoint {
    let path: String
    let ballotId: String
    let status: String
    
    var soapMessage: String? {
      return """
      <soap:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/">
      <soap:Body>
      <Update_Ballot_box_st_mashkif xmlns="http://tempuri.org/">
      <kalpi_id>\(ballotId)</kalpi_id>
      <status>\(status)</status>
      </Update_Ballot_box_st_mashkif>
      </soap:Body>
      </soap:Envelope>
      """
    }
  }

  struct UpdateVote: EndPoint {
    let path: String
    let ballotId: String
    let ballotNumber: String

    var soapMessage: String? {
      return """
      <soap:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/">
      <soap:Body>
      <Update_vote xmlns="http://tempuri.org/">
      <kapli_id>\(ballotId)</kapli_id>
      <kali_num>\(ballotNumber)</kali_num>
      </Update_vote>
      </soap:Body>
      </soap:Envelope>
      """
    }
  }

  struct UserAuthentication: EndPoint {
    let path: String
    let user: User

    var soapMessage: String? {
      return """
      <soap:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/">
      <soap:Body>
      <User_Authentication xmlns="http://tempuri.org/">
      <user>\(user.name)</user>
      <pass>\(user.password)</pass>
      <phone>\(user.phone)</phone>
      </User_Authentication>
      </soap:Body>
      </soap:Envelope>
      """
    }
  }

  struct UserPermission: EndPoint {
    let path: String
    let user: User

    var soapMessage: String? {
      return """
      <soap:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/">
      <soap:Body>
      <User_Permission xmlns="http://tempuri.org/">
      <user>\(user.name)</user>
      </User_Permission>
      </soap:Body>
      </soap:Envelope>
      """
    }
  }

  struct UserSendCode: EndPoint {
    let path: String
    let user: User

    var soapMessage: String? {
      return """
      <soap:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/">
      <soap:Body>
      <User_Send_code xmlns="http://tempuri.org/">
      <phone>\(user.phone)</phone>
      </User_Send_code>
      </soap:Body>
      </soap:Envelope>
      """
    }
  }

  struct GetAllNominee: EndPoint {
    let path: String
    var soapMessage: String? {
      return """
      <soap:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/">
      <soap:Body>
      <get_all_Nominee xmlns="http://tempuri.org/">
      <code></code>
      </get_all_Nominee>
      </soap:Body>
      </soap:Envelope>
      """
    }
  }
}
