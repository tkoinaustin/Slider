//
//  GameModel.swift
//  Slider
//
//  Created by Tom Nelson on 10/12/16.
//  Copyright © 2016 TKO Solutions. All rights reserved.
//

import UIKit

struct Coordinate {
  var row: Int
  var col: Int
  
  func move(_ direction: Direction) -> Coordinate? {
    
    switch direction {
    case .up:
      if self.row == 0 { return nil }
      return Coordinate(row:self.row - 1, col:self.col)
    case .down:
      if self.row == Rows - 1 { return nil }
      return Coordinate(row:self.row + 1, col:self.col)
    case .left:
      if self.col == 0 { return nil }
      return Coordinate(row:self.row, col:self.col - 1)
    case .right:
      if self.col == Columns - 1 { return nil }
      return Coordinate(row:self.row, col:self.col + 1)
    }
  }
  
}

enum Board {
  case moveZeroSpaces, moveOneSpace, moveTwoSpaces
}

class GameModel {
  
  private var gameBoard: [[Int]]!
  
  private var zeroMoveBoard: [[Int]]!
  private var oneMoveBoard: [[Int]]?
  private var twoMoveBoard: [[Int]]?
  
  private var gameBoardBlocks = [BlockModel]()
  
  private var oneMoveBlocks = [Int]()
  private var twoMoveBlocks = [Int]()
  private var movingBlocks = [Int]()
  
  private var gameLogic = GameModelLogic()
  private var direction: Direction?
  private var notThisDirection: Direction?
  private var board: Board = .moveOneSpace
  
  var start: UILabel!
  var finish: UILabel!
  var twoMove: UILabel!
  
  var gameViewModelUpdateUI: (() -> ()) = { _ in }

  var blockCount: Int {
    return gameBoardBlocks.count
  }
  
  func block(_ index: Int) -> BlockModel? {
    guard index >= 0 && index < gameBoardBlocks.count else { return nil }
    
    return gameBoardBlocks[index]
  }
  
  func allBlocks() -> [BlockModel] {
    return gameBoardBlocks
  }

  init(_ gameBoard: [[Int]]) {
    self.gameBoard = gameBoard
    gameBoardBlocks = initBlocks(grid: gameBoard)
  }
  
  private func initBlocks(grid: [[Int]]) -> [BlockModel] {
    var indices = Set<Int>()
    for row in 0..<Rows {
      for col in 0..<Columns {
        indices.insert(grid[row][col])
      }
    }
    
    var blocks = [BlockModel]()
    for index in indices.sorted() {
      blocks.append(BlockModel(index: index))
    }
    
    for row in 0..<Rows {
      for col in 0..<Columns {
        let block = blocks[(grid[row][col])]
        if let _ = block.type { continue }
        
        var wide = false
        var tall = false
        var blockType: BlockType!
        
        if col < Columns - 1 && grid[row][col] == grid[row][col+1] { wide = true }
        if row < Rows - 1 && grid[row][col] == grid[row+1][col] { tall = true }
        
        switch (wide, tall) {
        case (false, false): blockType = .small
        case (false, true): blockType = .tall
        case (true, false): blockType = .wide
        case (true, true): blockType = .big
        }
        
        block.origin = Coordinate(row: row, col: col)
        block.type = blockType
        
        block.blockModelUpdateGameboard = { board in
          self.updateGameboard(board)
        }
        
        block.blockModelBlockMovedBy = { amount, index -> Direction? in
          return self.moving(amount: amount, index: index)
        }
        
        block.blockModelMoveFinished = { _ in
          guard self.direction != nil else {
            self.board = .moveOneSpace
            return
          }
          
          self.gameModelMoveFinished(finalBoard: self.board)
          self.direction = nil
          self.board = .moveOneSpace
        }
      }
    }
    
    return blocks
  }
  
  func updateGameboard(_ board: Board) {
    print("updateGameboard \(board)")
    self.board = board
    switch board {
    case .moveTwoSpaces: movingBlocks = twoMoveBlocks
    case .moveOneSpace,
         .moveZeroSpaces: movingBlocks = oneMoveBlocks
    }
  }
  
  func moving(amount: CGPoint, index: Int) -> Direction? {
    if let direction = direction { // move by amount in direction if direction is set
      moveBy(amount, direction)
      
      return direction
    } else { //set game boards and direction
      if let dir = gameLogic.setDirection(x: amount.x, y: amount.y){
        if setGameplayForDirection(dir, index) {
          self.direction = dir
          
          return direction
        }
      }
    }
    
    return nil
  }

  func moveBy(_ amount: CGPoint, _ direction: Direction) {
    for index in movingBlocks {
      block(index)?.moveBy(amount, direction)
    }
  }
  
  func gameModelMoveFinished(finalBoard board: Board) {
    notThisDirection = nil
    updateGameboardForFinishPosition(board)
    updateBlockOriginsForBoard(gameBoard)
    resetBlocks()
    gameViewModelUpdateUI()
  }
  
  private func updateGameboardForFinishPosition(_ board: Board) {
    print("update GAMEBOARD For Finish Position \(board) *******")
    switch board {
    case .moveZeroSpaces: gameBoard = zeroMoveBoard
    case .moveOneSpace: gameBoard = oneMoveBoard
    case .moveTwoSpaces: gameBoard = twoMoveBoard
    }
    
    oneMoveBoard = nil
    twoMoveBoard = nil
  }
  
  private func updateBlockOriginsForBoard(_ gameboard: [[Int]]){
    for row in (0..<Rows).reversed() {
      for col in (0..<Columns).reversed() {
        gameBoardBlocks[gameboard[row][col]].origin = Coordinate(row: row, col: col)
      }
    }
  }
  
  private func resetBlocks() {
    print("resetting double move legal and in double move to false for all blocks")
    for block in gameBoardBlocks {
      block.doubleMoveLegal = false
      block.inDoubleMove = false
    }
  }
  
  func setGameplayForDirection(_ direction: Direction, _ index: Int) -> Bool {
    let canMove = setOutcomesForMove(direction, index)
    if !canMove {
      notThisDirection = direction
      return false
    }
    
    showGameboardsForMove(start, finish, twoMove)
    setMinMaxMove(direction)
    return true
  }

  private func setMinMaxMove(_ direction: Direction) {
    for block in gameBoardBlocks {
      block.setMinMaxMove(direction)
    }
  }
  
  // Set the three grids, zero, one and two moveGrid
  private func setOutcomesForMove(_ direction: Direction, _ index: Int) -> Bool {
    guard self.direction == nil else { return true }
    guard notThisDirection != direction else { return false }

    print("setOutcomesForMove block \(index) \(direction)")
    
    zeroMoveBoard = gameBoard
    
    guard let oneMoveBoard = gameLogic.newGridForMove(zeroMoveBoard, index, direction) else { return false}
    self.oneMoveBoard = oneMoveBoard
    oneMoveBlocks = blocksThatMoved(startGrid: zeroMoveBoard, endGrid: oneMoveBoard)
    movingBlocks = oneMoveBlocks
    print("oneMoveBlocks \(oneMoveBlocks)")
    
    guard let twoMoveBoard = gameLogic.newGridForMove(oneMoveBoard, index, direction) else { return true }
    self.twoMoveBoard = twoMoveBoard
    twoMoveBlocks = blocksThatMoved(startGrid: oneMoveBoard, endGrid: twoMoveBoard)
    print("twoMoveBlocks \(twoMoveBlocks)")

    for index in twoMoveBlocks {
      if oneMoveBlocks.contains(index) {
        block(index)?.doubleMoveLegal = true
      }
    }
    
    return true
  }

  private func blockOrigin(block: Int) -> (Coordinate)? {
    for row in 0..<Rows {
      for col in 0..<Columns {
        if gameBoard[row][col] == block { return (Coordinate(row: row, col: col)) }
      }
    }
    return nil
  }
  // logic
  private func blocksThatMoved(startGrid: [[Int]], endGrid: [[Int]]) -> [Int] {
    var indices = Set<Int>()
    for row in 0..<Rows {
      for col in 0..<Columns {
        if startGrid[row][col] != endGrid[row][col] {
          indices.insert(endGrid[row][col])
        }
      }
    }
    indices.remove(0)
    
    return Array(indices)
  }
  
  // throw away code, diagnostics to show grids on main UI for debugging
  private func showGameboardsForMove(_ start: UILabel, _ oneMove: UILabel, _ twoMove: UILabel) {
    var msg = "current grid: \n"
    msg += printGameboard(grid: gameBoard)
    start.text = msg
    
    msg = "single move: \n"
    if let oneMoveBoard = oneMoveBoard {
      msg += printGameboard(grid: oneMoveBoard)
    } else {
      msg = "next move grid:  "
    }
    oneMove.text = msg
    
    msg = "double move: \n"
    if let twoMoveBoard = twoMoveBoard {
      msg += printGameboard(grid: twoMoveBoard)
    } else {
      msg = "two move board:\n double move not legal"
    }
    twoMove.text = msg
  }
  
  func printGameboard(grid: [[Int]]) -> String {
    var  desc = ""
    for row in 0..<Rows {
      for col in 0..<Columns {
        desc += "[\(grid[row][col])]"// + col == Columns - 1 ? "\n" : ", "
        desc += col == Columns - 1 ? "\n" : ", "
      }
    }
    return desc
  }
}
