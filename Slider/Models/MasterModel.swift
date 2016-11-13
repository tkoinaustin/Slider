//
//  MasterModel.swift
//  Slider
//
//  Created by Tom Nelson on 10/25/16.
//  Copyright © 2016 TKO Solutions. All rights reserved.
//

import UIKit

class MasterModel: NSObject, NSCoding {
  
  var puzzles = Puzzles()
  var timer = TimeInterval()
  var game = GameModel()
  
  required convenience init?(coder aDecoder: NSCoder) {
    self.init()
    puzzles = aDecoder.decodeObject(forKey: "puzzles") as! Puzzles
    timer = aDecoder.decodeObject(forKey: "timer") as! TimeInterval
    game = aDecoder.decodeObject(forKey: "game") as! GameModel
  }
  
  func encode(with aCoder: NSCoder) {
    aCoder.encode(puzzles, forKey: "puzzles")
    aCoder.encode(timer, forKey: "timer")
    aCoder.encode(game, forKey: "game")
  }
}
