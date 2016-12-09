//
//  MasterModel.swift
//  Slider
//
//  Created by Tom Nelson on 10/25/16.
//  Copyright © 2016 TKO Solutions. All rights reserved.
//

import UIKit

class MasterModel: NSObject, NSCoding {
  
  var puzzles = Puzzles() // not needed, just decode from Archiver
  var game = GameModel()  // not needed, just decode from Archiver
  var history = [HistoryModel]() // This should be a dictionary, not an array

  required convenience init?(coder aDecoder: NSCoder) {
    self.init()
    
    guard let puzzles = aDecoder.decodeObject(forKey: "puzzles") as? Puzzles
      else { return nil }
    guard let game = aDecoder.decodeObject(forKey: "game") as? GameModel
      else { return nil }
    guard let history = aDecoder.decodeObject(forKey: "history") as? [HistoryModel]
      else { return nil }
    
    self.puzzles = puzzles
    self.game = game
    self.history = history
  }
  
  func encode(with aCoder: NSCoder) {
    aCoder.encode(puzzles, forKey: "puzzles")
    aCoder.encode(game, forKey: "game")
    aCoder.encode(history, forKey: "history")
  }
}
