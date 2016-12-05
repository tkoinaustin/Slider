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
  var gameTime: TimeInterval!
  private(set) var completed = false
  private(set) var datePlayed = Date()
  private(set) var controlBar = ControlBarViewModel()
  private(set) var moveData = [GameMoveData]() { didSet {
    controlBar.moveDataCount = moveData.count
  }}
  
  init(name: String, completed: Bool, datePlayed: Date, gameTime: TimeInterval, moveData: [GameMoveData]) {
    self.name = name
    self.completed = completed
    self.datePlayed = datePlayed
    self.gameTime = gameTime
    self.moveData = moveData
  }
  
  override init() {
    self.name = ""
    self.completed = false
    self.datePlayed = Date()
    self.gameTime = 0
    self.moveData = [GameMoveData]()
  }
  
  func copy(_ game: GameModel) {
    self.name = game.name
    self.completed = game.completed
    self.datePlayed = game.datePlayed
    self.gameTime = game.gameTime
    self.moveData = game.moveData
  }
  
  required convenience init?(coder aDecoder: NSCoder) {
    guard let name = aDecoder.decodeObject(forKey: "name") as? String
      else { return nil }
    let completed = aDecoder.decodeBool(forKey: "completed")
    guard let datePlayed = aDecoder.decodeObject(forKey: "datePlayed") as? Date
      else { return nil }
    guard let gameTime = aDecoder.decodeObject(forKey: "gameTime") as? TimeInterval
      else { return nil }
    guard let moveData = aDecoder.decodeObject(forKey: "moveData") as? [GameMoveData]
      else { return nil }
    self.init(name: name,
              completed: completed,
              datePlayed: datePlayed,
              gameTime: gameTime,
              moveData: moveData)
  }
  
  func encode(with aCoder: NSCoder) {
    aCoder.encode(name, forKey: "name")
    aCoder.encode(completed, forKey: "completed")
    aCoder.encode(datePlayed, forKey: "datePlayed")
    aCoder.encode(gameTime, forKey: "gameTime")
    aCoder.encode(moveData, forKey: "moveData")
  }

  var moves: Int {
    return moveData.count
  }
  
  func clearMoveData() {
    moveData.removeAll()
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
