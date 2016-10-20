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
  
}

class GameModel {
  
  private var gameBoard: [[Int]]!
  private var zeroMoveBoard: [[Int]]!
  private var oneMoveBoard: [[Int]]?
  private var twoMoveBoard: [[Int]]?
  private var gameBoardBlocks = [BlockModel]()
  private var oneMoveBlocks = [BlockModel]()
  private var twoMoveBlocks = [BlockModel]()
  private var gameLogic = GameModelLogic()
  
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
    setNeighbors(grid: gameBoard)
  }
  
  func setMinMaxMove(_ direction: Direction) {
    for block in gameBoardBlocks {
      block.setMinMaxMove(direction)
    }
  }
  
  func setNeighborsForGameGrid() {
    print("----- setNeighborsForGameGrid -----")
    setNeighbors(grid: gameBoard)
  }
  
  func setNeighborsForOneMoveGrid() {
    print("----- setNeighborsForOneMoveGrid -----")
    setNeighbors(grid: oneMoveBoard!)
  }
  
  func setNeighbors(grid: [[Int]]) {
    gameLogic.setNeighbors(grid: grid, blocks: gameBoardBlocks)
  }
  
  func setOutcomesForMove(_ direction: Direction, _ index: Int) {
    oneMoveBlocks.removeAll()
    for block in gameBoardBlocks {
      oneMoveBlocks.append(BlockModel(model: block))
    }
    gameLogic.setNeighbors(grid: gameBoard!, blocks: oneMoveBlocks)
    oneMoveBlocks[index].move(direction)
    oneMoveBoard = gameLogic.makeGameboard(blocks: oneMoveBlocks)
    gameLogic.setNeighbors(grid: oneMoveBoard!, blocks: oneMoveBlocks)
    
    twoMoveBlocks.removeAll()
    twoMoveBoard = nil
    
    guard oneMoveBlocks[index].canMove(direction: direction) else { return }
    // double move is legal so calculate double game board
    
    for block in oneMoveBlocks {
      twoMoveBlocks.append(BlockModel(model: block))
    }
    gameLogic.setNeighbors(grid: oneMoveBoard!, blocks: twoMoveBlocks)
    twoMoveBlocks[index].move(direction)
    twoMoveBoard = gameLogic.makeGameboard(blocks: twoMoveBlocks)
    gameLogic.setNeighbors(grid: twoMoveBoard!, blocks: twoMoveBlocks)

    print("setting double move legal true for block \(index)")
    
    block(index)!.doubleMoveLegal = true
    guard block(index)?.neighbors(direction)?.count == 1 else { return }
    guard let neighbor = block(index)?.neighbors(direction)?.first else { return }
    guard neighbor.index != EmptySpace else { return }
    neighbor.doubleMoveLegal = true
    print("setting double move legal true for block \(neighbor.index!)")

    guard let secondNeighbor = block(neighbor.index)?.neighbors(direction)?.first else { return }
    guard secondNeighbor.index != EmptySpace else { return }
    secondNeighbor.doubleMoveLegal = true
    print("setting double move legal true for block \(secondNeighbor.index!)")
  }

  func blockOrigin(block: Int) -> (Coordinate)? {
    for row in 0..<Rows {
      for col in 0..<Columns {
        if gameBoard[row][col] == block { return (Coordinate(row: row, col: col)) }
      }
    }
    return nil
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
      }
    }
    
    return blocks
  }
  
  func updateGameboardForMove(_ board: Board) {
    gameBoard =  board == .moveZeroSpaces ? oneMoveBoard : twoMoveBoard
    gameLogic.setNeighbors(grid: gameBoard, blocks: gameBoardBlocks)
    oneMoveBoard = nil
    twoMoveBoard = nil
  }
  
  func resetDoubleMoveLegal() {
    print("setting double move legal to false for all blocks")
    for block in gameBoardBlocks {
      block.doubleMoveLegal = false
    }
  }
  
  func resetInDoubleMove() {
    for block in gameBoardBlocks {
      block.inDoubleMove = false
    }
  }
  
  func updateBlockOriginsForMove(_ board: Board){
    let source = board == .moveZeroSpaces ? oneMoveBlocks : twoMoveBlocks
    for idx in 1..<source.count {
      gameBoardBlocks[idx].origin = source[idx].origin
    }
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
  
  func showGameboardsForCompletion(_ start: UILabel, _ finish: UILabel, _ twoMove: UILabel) {
    var msg = "gameboard: \n"
    msg += printGameboard(grid: gameBoard)
    start.text = msg
    
    msg = "single move: \n"
    if let oneMoveBoard = oneMoveBoard {
      msg += printGameboard(grid: oneMoveBoard)
    } else {
      msg = "next move grid:  "
    }
    finish.text = msg
    
    msg = "double move: \n"
    if let twoMoveBoard = twoMoveBoard {
      msg += printGameboard(grid: twoMoveBoard)
    } else {
      msg = "two move board:\n double move not legal"
    }
    twoMove.text = msg
  }

  func showGameboardsForMove(_ start: UILabel, _ finish: UILabel, _ twoMove: UILabel) {
    var msg = "current grid: \n"
    msg += printGameboard(grid: gameBoard)
    start.text = msg
    
    msg = "single move grid: \n"
    if let oneMoveBoard = oneMoveBoard {
      msg += printGameboard(grid: oneMoveBoard)
    } else {
      msg = "next move grid:  "
    }
    finish.text = msg
    
    msg = "double move grid: \n"
    if let twoMoveBoard = twoMoveBoard {
      msg += printGameboard(grid: twoMoveBoard)
    } else {
      msg = "two move board:\n double move not legal"
    }
    twoMove.text = msg
  }

}
