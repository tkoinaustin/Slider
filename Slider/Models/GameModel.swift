//
//  GameModel.swift
//  Slider
//
//  Created by Tom Nelson on 10/25/16.
//  Copyright © 2016 TKO Solutions. All rights reserved.
//

import UIKit

struct GameMoveData {
  var block: Int32
  var direction: Direction?
  var grid: [[Int32]]

  init?(coder aDecoder: NSCoder) {
    block = aDecoder.decodeCInt(forKey: "block")
    direction = aDecoder.decodeObject(forKey: "direction") as? Direction // ?? .up
    grid = aDecoder.decodeObject(forKey: "grid") as? [[Int32]] ?? [[Int32]]()
  }
  
  func encode(with aCoder: NSCoder) {
    aCoder.encodeCInt(block, forKey: "block")
    aCoder.encodeConditionalObject(direction, forKey: "direction")
    aCoder.encodeConditionalObject(grid, forKey: "grid")
  }
}

class GameModel {
  private var completed = false
  private var datePlayed = Date()
  private var gameTime: TimeInterval!
  private var movedata = [GameMoveData]()
  
  
  required convenience init?(coder aDecoder: NSCoder) {
    self.init()
    completed = aDecoder.decodeBool(forKey: "completed")
    movedata = aDecoder.decodeObject(forKey: "movedata") as! [GameMoveData]
    datePlayed = aDecoder.decodeObject(forKey: "datePlayed") as! Date
    gameTime = aDecoder.decodeObject(forKey: "gameTime") as! TimeInterval
    
  }
  
  func encode(with aCoder: NSCoder) {
    aCoder.encode(completed, forKey: "completed")
    aCoder.encode (movedata, forKey: "movedata")
    aCoder.encode(datePlayed, forKey: "datePlayed")
    aCoder.encode(gameTime, forKey: "gameTime")
  }

  var moves: Int {
    return movedata.count
  }
  
  func loadGame() {
    
  }
  
  func saveGame() {
    
  }
  
  func move(index: Int) -> GameMoveData? {
    guard index < movedata.count else { return nil }
    guard index >= 0 else { return nil }
    
    return movedata[index]
  }
  
  func push(singleMove: GameMoveData) {
    movedata.append(singleMove)
  }
  
  func pop() -> GameMoveData? {
    return movedata.popLast()
  }
}
