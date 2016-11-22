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
    guard let puzzles = aDecoder.decodeObject(forKey: "puzzles") as? Puzzles else { return nil }
    guard let timer = aDecoder.decodeObject(forKey: "timer") as? TimeInterval else { return nil }
    guard let game = aDecoder.decodeObject(forKey: "game") as? GameModel else { return nil }
    self.puzzles = puzzles
    self.timer = timer
    self.game = game 
  }
  
  func encode(with aCoder: NSCoder) {
    aCoder.encode(puzzles, forKey: "puzzles")
    aCoder.encode(timer, forKey: "timer")
    aCoder.encode(game, forKey: "game")
  }
}
