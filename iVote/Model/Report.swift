//
//  Report.swift
//  iVote
//
//  Created by Hasan Sa on 05/10/2018.
//  Copyright © 2018 Hasan Sa. All rights reserved.
//

import Foundation

enum ReportType: Int {
  case stabilization = 0
  case spectator
  case notes
  case disturbance
}

struct Report {
  let message: String
  let subject: String
  let isEnabled: Bool
}
