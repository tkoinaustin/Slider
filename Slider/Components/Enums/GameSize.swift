//
//  GameSize.swift
//  Slider
//
//  Created by Tom Nelson on 1/10/17.
//  Copyright © 2017 TKO Solutions. All rights reserved.
//

import UIKit

var gameSize: GameSize!

enum GameSize: String {
  case small, medium, large
  
  var font: UIFont {
    switch self{
    case .small: return UIFont(name: ".SFUIText", size: 15)!
    case .medium: return UIFont(name: ".SFUIText", size: 18)!
    case .large: return UIFont(name: ".SFUIText", size: 24)!
    }
  }
  
  var corner: CGFloat {
    switch self{
    case .small: return 5
    case .medium: return 7
    case .large: return 10
    }
  }
  
  var border: CGFloat {
    switch self{
    case .small: return 10
    case .medium: return 14
    case .large: return 20
    }
  }
  
  var buttonSize: CGFloat {
    switch self {
    case .small: return 16
    case .medium: return 20
    case .large: return 25
    }
  }
  
  var layout: CGFloat {
    switch self {
    case .small: return 8 - 1
    case .medium: return 8 - 1.5
    case .large: return 8 - 2
    }
  }
  
  var shadowRadius: CGFloat {
    switch self {
    case .small: return  1
    case .medium: return 1.5
    case .large: return 2
    }
  }
  
  var shadowOffset: CGSize {
    switch self {
    case .small: return CGSize(width: 0, height: 0.5)
    case .medium: return CGSize(width: 0, height: 1)
    case .large: return CGSize(width: 0, height: 2)
    }
  }

}

