//
//  Alerts.swift
//  Slider
//
//  Created by Tom Nelson on 1/12/17.
//  Copyright © 2017 TKO Solutions. All rights reserved.
//

import UIKit

enum Alerts {
  case winner, replay
  
  var title: String {
    switch self {
    case .winner: return "Winner, winner, chicken dinner!"
    case .replay: return "You just never get tired of that game, do you?"
    }
  }
  
  var message: String {
    switch self {
    case .winner: return "Good job"
    case .replay: return ""
    }
  }
}
