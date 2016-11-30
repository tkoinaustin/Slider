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
    if moveNumber > highestMoveNumber { highestMoveNumber = moveNumber }
      updateUI()
  }}
  var highestMoveNumber: Int = 0
  var time: String = ""
  var timer: Timer?
  var updateUI: (() -> ()) = {}
  var updateBlocksToMoveNumber: ((Int) -> ()) = {_ in }

  required convenience init?(coder aDecoder: NSCoder) {
    self.init()
    moveNumber = aDecoder.decodeInteger(forKey: "moveNumber")
    time = aDecoder.decodeObject(forKey: "time") as! String
  }
  
  func encode(with aCoder: NSCoder) {
    aCoder.encode(moveNumber, forKey: "moveNumber")
    aCoder.encode(time, forKey: "time")
  }
  
  func forward() {
    guard moveNumber < highestMoveNumber else { return }
    moveNumber += 1
    updateBlocksToMoveNumber(moveNumber)
  }
  
  func  backward () {
    guard moveNumber > 0 else { return }
    moveNumber -= 1
    updateBlocksToMoveNumber(moveNumber)
  }
}
