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
  
  var moveDataCount: Int = 0
  var backEnabled: Bool { return moveDataCount > 0 }
  var forwardEnabled: Bool { return moveNumber < moveDataCount - 1 }
  
  var time: String = ""
  var timer: Timer?
  
  var updateUI: (() -> ()) = {}
  var updateBlocksToMoveNumber: ((Int) -> ()) = {_ in }
  var trimMoveData: ((Int) -> ()) = { _ in }

  required convenience init?(coder aDecoder: NSCoder) {
    self.init()
    moveNumber = aDecoder.decodeInteger(forKey: "moveNumber")
    if let time1 = aDecoder.decodeObject(forKey: "time") as? String { time = time1 }
  }
  
  func encode(with aCoder: NSCoder) {
    aCoder.encode(moveNumber, forKey: "moveNumber")
    aCoder.encode(time, forKey: "time")
  }
  
  func forward() {
    moveNumber += 1
    updateBlocksToMoveNumber(moveNumber)
  }
  
  func  backward () {
    guard moveNumber > 0 else { return }
    moveNumber -= 1
    updateBlocksToMoveNumber(moveNumber)
  }
}
