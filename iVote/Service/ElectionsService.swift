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
  // MARK: - API

  /// <#Description#>
  ///
  /// - Parameter completion: <#completion description#>
  func getAllNominee(completion:(() -> Void)? = nil) {
    self.queue.async {
      let allNomineeEndPoint = EndPoints.GetAllNominee(code: "1")
      let resource = Resource(endPoint: allNomineeEndPoint)
      
      self.loadXMLAccessor(resource: resource) { (xmlAccessor, error) in
        guard error == nil, let xml = xmlAccessor else { return }
        let elements = xml["get_all_NomineeResponse", "get_all_NomineeResult", "Get_all_Nominee", "Nominee"]
        let iterator = elements.makeIterator()
        while let next = iterator.next() {
          if let text = next["Nominee_new_name"].text {
            print(text)
          }
        }
      }
    }
  }

  /// <#Description#>
  ///
  /// - Parameters:
  ///   - user: <#user description#>
  ///   - completion: <#completion description#>
  func authenticate(user: User, completion:((_ phoneNumber: String?) -> Void)? = nil) {
    self.queue.async {
      let userAuthenticationEndPoint = EndPoints.UserAuthentication(user: user)
      let resource = Resource(endPoint: userAuthenticationEndPoint)
      self.loadXMLAccessor(resource: resource) { (xmlAccessor, error) in
        guard error == nil, let xml = xmlAccessor else {
          completion?(nil)
          return
        }
        let phoneNumber = xml["User_AuthenticationResponse", "User_AuthenticationResult", "User", "User_phone"].text
        completion?(phoneNumber)
      }
    }
  }

  /// <#Description#>
  ///
  /// - Parameters:
  ///   - user: <#user description#>
  ///   - completion: <#completion description#>
  func getCode(user: User, completion:((_ code: String?) -> Void)? = nil) {
    self.queue.async {
      let userAuthenticationEndPoint = EndPoints.UserSendCode(user: user)
      let resource = Resource(endPoint: userAuthenticationEndPoint)

      self.loadXMLAccessor(resource: resource) { (xmlAccessor, error) in
        guard error == nil, let xml = xmlAccessor else {
          completion?(nil)
          return
        }
        let code = xml["User_Send_codeResponse", "User_Send_codeResult", "User_code"].text
        completion?(code)
      }
    }
  }
  
}
