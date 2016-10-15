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
  private var oneMoveBoard: [[Int]]?
  private var twoMoveBoard: [[Int]]?
  private var gameBoardBlocks = [BlockModel]()
  private var oneMoveBlocks = [BlockModel]()
  private var twoMoveBlocks: [BlockModel]!
  private var gameLogic = GameModelLogic()
  
  var blockCount: Int {
    return gameBoardBlocks.count
  }
  
  func block(_ index: Int) -> BlockModel? {
    guard index >= 0 && index < gameBoardBlocks.count else { return nil }
    
    return gameBoardBlocks[index]
  }

  init(gameBoard: [[Int]]) {
    self.gameBoard = gameBoard
    gameBoardBlocks = initBlocks(grid: gameBoard)
    setNeighbors(grid: gameBoard)
  }
  
  func setNeighbors(grid: [[Int]]) {
    gameLogic.setNeighbors(grid: grid, blocks: gameBoardBlocks)
  }
  
  func setGameboardsForMove(_ direction: Direction, _ index: Int) {
    // Do the stuff here to calculate oneMoveBoard, twoMoveBoard, etc
    for block in gameBoardBlocks {
      oneMoveBlocks.append(BlockModel(model: block))
    }
    gameLogic.setNeighbors(grid: gameBoard!, blocks: oneMoveBlocks)
    oneMoveBlocks[index].updateForDirection(direction)
    oneMoveBoard = gameLogic.rebuildGrid(grid: gameBoard, blocks: oneMoveBlocks)
    gameLogic.setNeighbors(grid: oneMoveBoard!, blocks: oneMoveBlocks)
    print("\ngame grid: ")
    print(dumpGrid(grid: gameBoard))
    print("\none move grid: ")
    print(dumpGrid(grid: oneMoveBoard!))
  }
  
  func buildOneMoveGrid(block: Int, direction: Direction) {
    
  }
  
  func buildTwoMoveGrid(block: Int, direction: Direction) {
    
  }
  
  func blockOrigin(block: Int) -> (Coordinate)? {
    for row in 0..<Rows {
      for col in 0..<Columns {
        if gameBoard[row][col] == block { return (Coordinate(row: row, col: col)) }
      }
    }
    return nil
  }
  
  func isMoveLegal(block: Int, direction: Direction) -> Bool {
    return false
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
  
  func updateGridForSingleMove() {
    gameBoard = oneMoveBoard
    gameLogic.setNeighbors(grid: gameBoard, blocks: gameBoardBlocks)
    oneMoveBoard = nil
    twoMoveBoard = nil
  }
  
  func dumpGrid(grid: [[Int]]) -> String {
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
