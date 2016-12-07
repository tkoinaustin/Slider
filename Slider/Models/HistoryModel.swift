//
//  HistoryModel.swift
//  Slider
//
//  Created by Mac Daddy on 11/13/16.
//  Copyright © 2016 TKO Solutions. All rights reserved.
//

import UIKit

class HistoryModel: NSObject, NSCoding {
  var name: String!
  var index: Int = 0
  var bestMoves: Int = 0
  var bestTime: TimeInterval = 1_000_000
  var won = false
  var history: [GameModel]?
  
  required convenience init?(coder aDecoder: NSCoder) {
    self.init()
    if let name = aDecoder.decodeObject(forKey: "name")
      as? String { self.name = name }
    index = aDecoder.decodeInteger(forKey: "index")
    bestMoves = aDecoder.decodeInteger(forKey: "bestMoves")
    if let bestTime = aDecoder.decodeObject(forKey: "bestTime")
      as? TimeInterval { self.bestTime = bestTime }
    won = aDecoder.decodeBool(forKey: "won")
    history = aDecoder.decodeObject(forKey: "history") as? [GameModel]
  }
  
  func encode(with aCoder: NSCoder) {
    aCoder.encode(name, forKey: "name")
    aCoder.encode(index, forKey: "index")
    aCoder.encode(bestMoves, forKey: "bestMoves")
    aCoder.encode(bestTime, forKey: "bestTime")
    aCoder.encode(won, forKey: "won")
    aCoder.encode(history, forKey: "history")
  }
  
  func loadHistory() {
  
  }
  
  func saveHistory() {
    // serialize, coder, etc
  }
  
  func addGame(game: GameModel) {
    name = game.name
    index = game.index
    
    if game.gameTime < bestTime { bestTime = game.gameTime }
    if game.moveData.count < bestMoves { bestMoves = game.moveData.count }
    if game.won { won = true }
    
    if var history = history {
      history.append(game)
    } else {
      history = [game]
    }
  }
}
