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
    case .winner: return Quotes.winner
    case .replay: return Quotes.replay
    }
  }
  
  var message: String {
    switch self {
    case .winner: return Quotes.congrats
    case .replay: return ""
    }
  }
}
