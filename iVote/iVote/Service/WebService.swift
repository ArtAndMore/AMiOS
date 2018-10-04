//
//  WebService.swift
//  iVote
//
//  Created by Hasan Sa on 04/10/2018.
//  Copyright © 2018 Hasan Sa. All rights reserved.
//

import Foundation
import SwiftyXMLParser

/// <#Description#>
class WebService {
  let queue = DispatchQueue(label: "com.iVote.service_queue")
  
  private lazy var session: URLSession = {
    let config = URLSessionConfiguration.default
    return URLSession(configuration: config)
  }()
  
  /// <#Description#>
  ///
  /// - invalidResponseData: <#invalidResponseData description#>
  enum WebServiceError: Error {
    case invalidResponseData
  }
  
  /// <#Description#>
  ///
  /// - Parameters:
  ///   - resource: <#resource description#>
  ///   - callback: <#callback description#>
  func load<A: Codable>(resource: CodableResource<A>, callback: @escaping (A?, Error?) -> Void) {
    guard let request = resource.request else {
      return
    }
    self.session.dataTask(with: request) { (data, response, error) in
      self.queue.async {
        guard error == nil, let data = data else {
          print(error!)
          callback(nil, error!)
          return
        }
        do {
          let result = try JSONDecoder().decode(A.self, from: data)
          callback(result, nil)
        } catch {
          callback(nil, error)
        }
      }
      }.resume()
  }
  
  /// <#Description#>
  ///
  /// - Parameters:
  ///   - resource: <#resource description#>
  ///   - callback: <#callback description#>
  func loadXMLAccessor(resource: Resource, callback: @escaping (XML.Accessor?, Error?) -> Void) {
    guard let request = resource.request else {
      return
    }
    self.session.dataTask(with: request) { (data, response, error) in
      self.queue.async {
        guard error == nil, let responseData = data else {
          callback(nil, error)
          return
        }
        do {
          guard let responseString = String(data: responseData, encoding: String.Encoding.utf8) else {
            callback(nil, WebServiceError.invalidResponseData)
            return
          }
          let xml = try XML.parse(responseString)
          // access xml element
          let result = xml["soap:Envelope", "soap:Body"]
          
          callback(result, nil)
        } catch {
          callback(nil, error)
        }}
      }.resume()
  }
}
