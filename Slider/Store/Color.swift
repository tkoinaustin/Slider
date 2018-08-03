//
//  Color.swift
//  Slider
//
//  Created by Tom Nelson on 1/10/17.
//  Copyright © 2017 TKO Solutions. All rights reserved.
//

import UIKit
//import Hue

extension UIColor {
  convenience init(hex:UInt32, alpha: CGFloat = 1.0) {
    let red = CGFloat((hex & 0xFF0000) >> 16) / CGFloat(255.0)
    let green = CGFloat((hex & 0x00FF00) >> 8) / CGFloat(255.0)
    let blue = CGFloat(hex & 0x0000FF) / CGFloat(255.0)
    self.init(red: red, green: green, blue: blue, alpha: alpha)
  }
}

struct Color {
  static var sky: UIColor {
    return UIColor(hex: 0x5795D2)
  }
  static var aqua: UIColor {
    return UIColor(hex: 0x4679AB)
  }
  static var ocean: UIColor {
    return UIColor(hex: 0x396590)
  }
  static var tungsten: UIColor {
    return UIColor(hex: 0x2D2E40)
  }
  static var steel: UIColor {
    return UIColor(hex: 0x686A86)
  }
  static var cayenne: UIColor {
    return UIColor(hex: 0x942027)
  }
  static var moss: UIColor {
    return UIColor(hex: 0x2D7F39)
  }
}
