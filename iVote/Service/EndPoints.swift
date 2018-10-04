//
//  EndPoints.swift
//  iVote
//
//  Created by Hasan Sa on 04/10/2018.
//  Copyright © 2018 Hasan Sa. All rights reserved.
//

import Foundation

struct EndPoints {

  struct CountVote: EndPoint {
    let ballotId: String
    let electedId: String
    let value: String

    var soapMessage: String? {
      return """
      <soap:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/">
      <soap:Body>
      <Count_vote xmlns="http://tempuri.org/">
      <kalpi_id>\(ballotId)/</kalpi_id>
      <nevhar_id>\(electedId)</nevhar_id>
      <val>\(value)</val>
      </Count_vote>
      </soap:Body>
      </soap:Envelope>
      """
    }
  }

  struct GetMainPageData: EndPoint {
    let ballotNumber: Int

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

  struct GetAllMainPageData: EndPoint {
    let invoke: String
    var soapMessage: String? {
      return """
      <soap:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/">
      <soap:Body>
      <Get_MainPage_data_all xmlns="http://tempuri.org/">
      <invok>\(invoke)</invok>
      </Get_MainPage_data_all>
      </soap:Body>
      </soap:Envelope>
      """
    }
  }

  struct GetVotedContact: EndPoint {
    let code: String

    var soapMessage: String? {
      return """
      <soap:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/">
      <soap:Body>
      <Get_Voted_Contact xmlns="http://tempuri.org/">
      <code>\(code)</code>
      </Get_Voted_Contact>
      </soap:Body>
      </soap:Envelope>
      """
    }

  }

  struct GetVotedContactByStatus: EndPoint {
    let status: Int

    var soapMessage: String? {
      return """
      <soap:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/">
      <soap:Body>
      <Get_Voted_Contact_by_Status xmlns="http://tempuri.org/">
      <StatusVote>\(status)</StatusVote>
      </Get_Voted_Contact_by_Status>
      </soap:Body>
      </soap:Envelope>
      """
    }
  }

  struct GetVotedContactByBallot: EndPoint {
    let status: Int
    let ballotNumber: Int

    var soapMessage: String? {
      return """
      <soap:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/">
      <soap:Body>
      <Get_Voted_Contact_by_kalpi xmlns="http://tempuri.org/">
      <StatusVote>\(status)</StatusVote>
      <kalpinum>\(ballotNumber)</kalpinum>
      </Get_Voted_Contact_by_kalpi>
      </soap:Body>
      </soap:Envelope>
      """
    }
  }

  struct GetAllBallotBox: EndPoint {
    let code: String

    var soapMessage: String? {
      return """
      <soap:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/">
      <soap:Body>
      <Get_all_ballot_box xmlns="http://tempuri.org/">
      <code>\(code)</code>
      </Get_all_ballot_box>
      </soap:Body>
      </soap:Envelope>
      """
    }
  }

  struct GetAllBallotBoxById: EndPoint {
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
    let id: String
    let firstName: String
    let middleName: String
    let lastName: String
    let isVote: Bool

    var soapMessage: String? {
      return """
      <soap:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/">
      <soap:Body>
      <Search_contact xmlns="http://tempuri.org/">
      <contact_fname>\(firstName)</contact_fname>
      <contact_lname>\(lastName)</contact_lname>
      <contact_id>\(id)</contact_id>
      <contact_father_name>\(middleName)</contact_father_name>
      <isvote>\(isVote.hashValue)</isvote>
      </Search_contact>
      </soap:Body>
      </soap:Envelope>
      """
    }
  }

  struct SearchContactById: EndPoint {
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

  struct SendMsgToControl: EndPoint {
    let user: String
    let message: String
    let subject: String

    var soapMessage: String? {
      return """
      <soap:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/">
      <soap:Body>
      <Send_msg_to_control xmlns="http://tempuri.org/">
      <sub>\(subject)</sub>
      <msg>\(message)</msg>
      <user>\(user)</user>
      </Send_msg_to_control>
      </soap:Body>
      </soap:Envelope>
      """
    }
  }

  struct UpdateBallotBoxPtakim: EndPoint {
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
    let code: String

    var soapMessage: String? {
      return """
      <soap:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/">
      <soap:Body>
      <get_all_Nominee xmlns="http://tempuri.org/">
      <code>\(code)</code>
      </get_all_Nominee>
      </soap:Body>
      </soap:Envelope>
      """
    }
  }
}
