//
//  Resource.swift
//  iVote
//
//  Created by Hasan Sa on 04/10/2018.
//  Copyright © 2018 Hasan Sa. All rights reserved.
//

import Foundation

enum HTTPMethod: String {
  case get = "GET"
  case post = "POST"
  case put = "PUT"
  case patch = "PATCH"
  case delete = "DELETE"
}

// MARK:- Resource
class Resource {
  let endPoint: EndPoint

  init(endPoint: EndPoint) {
    self.endPoint = endPoint
  }

  var request: URLRequest? {
    var components = URLComponents(string: endPoint.base)!
    components.path = endPoint.path
    if !endPoint.parameters.isEmpty {
      components.queryItems = [URLQueryItem]()
      endPoint.parameters.forEach { (key, value) in
        let queryItem = URLQueryItem(name: key, value: "\(value)")
        components.queryItems!.append(queryItem)
      }
    }
    guard let url = components.url else {
      return nil
    }

    var request = URLRequest(url: url)

    endPoint.headers.forEach {
      request.setValue($1, forHTTPHeaderField: $0)
      request.setValue($1, forHTTPHeaderField: $0)
    }

    request.httpMethod = endPoint.httpMethod.rawValue

    if let soapMessage = endPoint.soapMessage, endPoint.httpMethod == .post {
      request.httpBody = soapMessage.data(using: String.Encoding.utf8, allowLossyConversion: false)
    }
    return request
  }
}

class CodableResource<A: Codable>: Resource {}
