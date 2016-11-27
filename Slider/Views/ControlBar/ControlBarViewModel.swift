//
//  ControlBarViewModel.swift
//  Slider
//
//  Created by Tom Nelson on 11/10/16.
//  Copyright © 2016 TKO Solutions. All rights reserved.
//

import UIKit

class ControlBarViewModel: NSObject, NSCoding {
  var moveNumber: Int = 0 { didSet {
      updateUI()
  }}
  var time: String = ""
  var timer: Timer?
  var updateUI: (() -> ()) = {}

  // action forward
  // action back
  
  required convenience init?(coder aDecoder: NSCoder) {
    self.init()
    moveNumber = aDecoder.decodeInteger(forKey: "moveNumber")
    time = aDecoder.decodeObject(forKey: "time") as! String
  }
  
  func encode(with aCoder: NSCoder) {
    aCoder.encode(moveNumber, forKey: "moveNumber")
    aCoder.encode(time, forKey: "time")
  }

}
