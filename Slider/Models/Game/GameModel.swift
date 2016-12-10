//
//  GameModel.swift
//  Slider
//
//  Created by Tom Nelson on 10/25/16.
//  Copyright © 2016 TKO Solutions. All rights reserved.
//

import UIKit

class GameModel: NSObject, NSCoding {
  var name = ""
  var index: Int = 0
  var gameTime: TimeInterval!
  var won = false
  private(set) var datePlayed = Date()
  private(set) var controlBar = ControlBarViewModel()
  private(set) var moveData = [GameMoveData]() { didSet {
    controlBar.moveDataCount = moveData.count
  }}
  
  override init() {
    self.name = ""
    self.index = 0
    self.won = false
    self.datePlayed = Date()
    self.gameTime = 0
    self.moveData = [GameMoveData]()
  }
  
  func copy(_ game: GameModel) {
    self.name = game.name
    self.index = game.index
    self.won = game.won
    self.datePlayed = game.datePlayed
    self.gameTime = game.gameTime
    self.moveData = game.moveData
  }
  
  required convenience init?(coder aDecoder: NSCoder) {
    self.init()
    if let name = aDecoder.decodeObject(forKey: "name")
      as? String { self.name = name }
    index = aDecoder.decodeInteger(forKey: "index")
    won = aDecoder.decodeBool(forKey: "won")
    if let datePlayed = aDecoder.decodeObject(forKey: "datePlayed")
      as? Date { self.datePlayed = datePlayed }
    if let gameTime = aDecoder.decodeObject(forKey: "gameTime")
      as? TimeInterval { self.gameTime = gameTime }
    if let moveData = aDecoder.decodeObject(forKey: "moveData")
      as? [GameMoveData] { self.moveData = moveData }
  }
  
  func encode(with aCoder: NSCoder) {
    aCoder.encode(name, forKey: "name")
    aCoder.encode(index, forKey: "index")
    aCoder.encode(won, forKey: "won")
    aCoder.encode(datePlayed, forKey: "datePlayed")
    aCoder.encode(gameTime, forKey: "gameTime")
    aCoder.encode(moveData, forKey: "moveData")
  }

  var moves: Int {
    return moveData.count
  }
  
  func prepareForNewGame(_ gameboard: Gameboard) {
    moveData.removeAll()
    won = false
    gameTime = 0
    datePlayed = Date()
    index = gameboard.index
    name = gameboard.name
  }
  
  func setInitialGrid(_ grid: GameMoveData) {
    moveData.append(grid)
  }
  
  func assignControlBar(_ controlBar: ControlBarViewModel) {
    self.controlBar = controlBar
  }
  
  func move(index: Int) -> GameMoveData? {
    guard index < moveData.count else { return nil }
    guard index >= 0 else { return nil }
    
    return moveData[index]
  }
  
  func push(_ singleMove: GameMoveData) {
    trim(controlBar.moveNumber)
    controlBar.moveNumber += 1
    moveData.append(singleMove)
  }
  
  func pop() -> GameMoveData? {
    controlBar.moveNumber -= 1
    return moveData.popLast()
  }
  
  func trim(_ index: Int) {
    print("trimming moveData to \(index)")
    guard index < moveData.count else { return }
    let arraySlice = moveData[0...index]
    moveData = Array(arraySlice)

  }
}
