//
//  WebService.swift
//  iVote
//
//  Created by Hasan Sa on 04/10/2018.
//  Copyright © 2018 Hasan Sa. All rights reserved.
//

import Foundation
import SwiftyXMLParser
import Reachability

extension NSNotification.Name {
  static let ReachabilityIsReachable = NSNotification.Name("ReachabilityIsReachable")
  static let ReachabilityIsUnreachable = NSNotification.Name("ReachabilityIsUnreachable")
}

class WebService {
  let queue = DispatchQueue(label: "com.iVote.service_queue", attributes: .concurrent)
  
  private var session: URLSession {
    let config = URLSessionConfiguration.default
    return URLSession(configuration: config)
  }

  enum WebServiceError: Error {
    case invalidRequest
    case noNetworkConnection
    case invalidResponseData
  }
  private var reachability: Reachability!

  init() {
    self.setupReachability()
  }

  private func setupReachability() {
    reachability = Reachability()!

    reachability.whenUnreachable = { reachability in
      if reachability.connection == .none {
        NotificationCenter.default.post(name: NSNotification.Name.ReachabilityIsUnreachable, object: nil)
      }
    }

    reachability.whenReachable = { reachability in
      if reachability.connection != .none {
        NotificationCenter.default.post(name: NSNotification.Name.ReachabilityIsReachable, object: nil)
      }
    }
    do {
      try reachability.startNotifier()
    } catch {
      print("Unable to start notifier")
    }
  }

  func load<A: Codable>(resource: CodableResource<A>, callback: @escaping (A?, WebServiceError?) -> Void) {
    guard self.reachability.connection != .none else {
      callback(nil, WebServiceError.noNetworkConnection)
      return
    }
    guard let request = resource.request else {
      callback(nil, WebServiceError.invalidRequest)
      return
    }
    self.session.dataTask(with: request) { (data, response, error) in
      self.queue.async {
        guard error == nil, let data = data else {
          print(error!)
          callback(nil, WebServiceError.invalidResponseData)
          return
        }
        do {
          let result = try JSONDecoder().decode(A.self, from: data)
          callback(result, nil)
        } catch {
          callback(nil, WebServiceError.invalidResponseData)
        }
      }
      }.resume()
  }

  func loadXMLAccessor(resource: Resource, callback: @escaping (XML.Accessor?, WebServiceError?) -> Void) {
    guard self.reachability.connection != .none else {
      callback(nil, WebServiceError.noNetworkConnection)
      return
    }
      guard let request = resource.request else {
        callback(nil, WebServiceError.invalidRequest)
      return
    }
    self.queue.async {
      self.session.dataTask(with: request) { (data, response, error) in
        self.queue.async {
          guard error == nil, let responseData = data else {
            callback(nil, WebServiceError.invalidResponseData)
            return
          }
          do {
            guard let responseString = String(data: responseData, encoding: String.Encoding.utf8) else {
              callback(nil, WebServiceError.invalidResponseData)
              return
            }
            let xml = try XML.parse(responseString)
            // access xml element
            let result = xml["soap:Envelope",
                             "soap:Body"]

            callback(result, nil)
          } catch {
            callback(nil, WebServiceError.invalidResponseData)
          }}
        }.resume()

    }
  }
}
