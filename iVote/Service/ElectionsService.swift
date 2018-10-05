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

  private var user: User!

  private(set) var isAuthenticated: Bool {
    get {
      return UserDefaults.standard.bool(forKey: "isLoggedIn")
    }
    set {
      UserDefaults.standard.set(newValue, forKey: "isLoggedIn")
    }
  }

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
  func authenticate(user: User, completion:((_ success: Bool) -> Void)? = nil) {
    self.queue.async {
      self.user = user
      let userAuthenticationEndPoint = EndPoints.UserAuthentication(user: self.user)
      let resource = Resource(endPoint: userAuthenticationEndPoint)
      self.loadXMLAccessor(resource: resource) { (xmlAccessor, error) in
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

  func getCode(completion:@escaping ((_ code: String?) -> Void)) {
    self.queue.async {
      let userSendCodeEndPoint = EndPoints.UserSendCode(user: self.user)
      let resource = Resource(endPoint: userSendCodeEndPoint)

      self.loadXMLAccessor(resource: resource) { (xmlAccessor, error) in
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
  
}
