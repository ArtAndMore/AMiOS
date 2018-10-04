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
  case path = "PATCH"
  case delete = "DELETE"
}

// MARK:- EndPoint
protocol EndPoint {
  var base: String {get}
  var path: String {get}
  var soapMessage: String? {get}
  var httpMethod: HTTPMethod {get}
  var parameters: [String: String] {get set}
  var headers: [String: String] {get set}
}

extension EndPoint {
  var base: String {
    return "http://site.ashamsoft.com"
  }
  
  var path: String {
    return "/CRM/WebService.ASMX"
  }
  
  var httpMethod: HTTPMethod {
    return .post
  }
  
  var parameters: [String: String] {
    get {
      return [:]
    }
    set {}
  }
  
  var headers: [String: String] {
    get {
      var eHeaders: [String: String] = [:]
      if let soapMessage = self.soapMessage {
        eHeaders["Content-Type"] = "text/xml; charset=utf-8"
        eHeaders["Content-Length"] = String(soapMessage.count)
      }
      return eHeaders
    }
    set {}
  }
}

// MARK:- Resource
class Resource {
  let endPoint: EndPoint

  init(endPoint: EndPoint) {
    self.endPoint = endPoint
  }
}

class CodableResource<A: Codable>: Resource {}

// MARK:- Resource URLRequest
extension Resource {
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
