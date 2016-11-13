//
//  HistoryModel.swift
//  Slider
//
//  Created by Mac Daddy on 11/13/16.
//  Copyright © 2016 TKO Solutions. All rights reserved.
//

import UIKit

class HistoryModel: NSObject, NSCoding {
  var puzzle: Int32 = 0
  var history: [GameModel]?
  
  required convenience init?(coder aDecoder: NSCoder) {
    self.init()
    puzzle = aDecoder.decodeCInt(forKey: "puzzle")
    history = aDecoder.decodeObject(forKey: "history") as? [GameModel]
  }
  
  func encode(with aCoder: NSCoder) {
    aCoder.encodeCInt(puzzle, forKey: "puzzle")
    aCoder.encode(history, forKey: "history")
  }
  
  func loadHistory() {
  
  }
  
  func saveHistory() {
    // serialize, coder, etc
  }
  
  func addGame(game: GameModel) {
    if var history = history {
      history.append(game)
    } else {
      history = [game]
    }
  }
  
  func getGame(index: Int) -> (date: Date, time: TimeInterval, completed: Bool) {
  
    return (Date(), 1, true)
  }

}
