//
//  GameModel.swift
//  Slider
//
//  Created by Tom Nelson on 10/25/16.
//  Copyright © 2016 TKO Solutions. All rights reserved.
//

import UIKit

class GameMoveData: NSObject, NSCoding {
  var block: Int32
  var direction: Direction?
  var grid: [[Int32]]

  init(block: Int32, direction: Direction?, grid: [[Int32]]) {
    self.block = block
    self.direction = direction
    self.grid = grid
  }
  
  override init() {
    block = 0
    direction = nil
    grid = [[Int32]]()
  }
  
  required convenience init?(coder aDecoder: NSCoder) {
    let block = aDecoder.decodeInt32(forKey: "block")
    let dir = aDecoder.decodeInt32(forKey: "direction")
    let direction = Direction(rawValue: dir)
    guard let grid = aDecoder.decodeObject(forKey: "grid") as? [[Int32]] else { return nil }
    self.init(block: block, direction: direction, grid: grid)
  }
  
  func encode(with aCoder: NSCoder) {
    aCoder.encode(block, forKey: "block")
    aCoder.encode(direction!.rawValue, forKey: "direction")
    aCoder.encode(grid, forKey: "grid")
  }
}

class GameModel: NSObject, NSCoding {
  private(set) var completed = false
  private(set) var datePlayed = Date()
  private(set) var gameTime: TimeInterval!
  private(set) var moveData = [GameMoveData]()
  
  init(completed: Bool, datePlayed: Date, gameTime: TimeInterval, moveData: [GameMoveData]) {
    self.completed = completed
    self.datePlayed = datePlayed
    self.gameTime = gameTime
    self.moveData = moveData
  }
  
  override init() {
    self.completed = false
    self.datePlayed = Date()
    self.moveData = [GameMoveData]()
  }
  
  required convenience init?(coder aDecoder: NSCoder) {
    let completed = aDecoder.decodeBool(forKey: "completed")
    guard let moveData = aDecoder.decodeObject(forKey: "moveData") as? [GameMoveData]
      else { return nil }
    guard let datePlayed = aDecoder.decodeObject(forKey: "datePlayed") as? Date
      else { return nil }
    guard let gameTime = aDecoder.decodeObject(forKey: "gameTime") as? TimeInterval
      else { return nil }
    self.init(completed: completed, datePlayed: datePlayed, gameTime: gameTime, moveData: moveData)
  }
  
  func encode(with aCoder: NSCoder) {
    aCoder.encode(completed, forKey: "completed")
    aCoder.encode (moveData, forKey: "moveData")
    aCoder.encode(datePlayed, forKey: "datePlayed")
    aCoder.encode(gameTime, forKey: "gameTime")
  }

  var moves: Int {
    return moveData.count
  }
  
  func loadGame() {
    
  }
  
  func saveGame() {
    
  }
  
  func move(index: Int) -> GameMoveData? {
    guard index < moveData.count else { return nil }
    guard index >= 0 else { return nil }
    
    return moveData[index]
  }
  
  func push(singleMove: GameMoveData) {
    moveData.append(singleMove)
  }
  
  func pop() -> GameMoveData? {
    return moveData.popLast()
  }
}
