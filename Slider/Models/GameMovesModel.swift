//
//  GameMovesModel.swift
//  Slider
//
//  Created by Tom Nelson on 10/25/16.
//  Copyright © 2016 TKO Solutions. All rights reserved.
//

import UIKit

struct GameMoveData {
  var block: Int
  var direction: Direction
  var grid: [[Int]]
}

class GameMovesModel {
  private var completed = false
  private var datePlayed = Date()
  private var gameTime: TimeInterval!
  private var movedata = [GameMoveData]()
  
  var moves: Int {
    return movedata.count
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
