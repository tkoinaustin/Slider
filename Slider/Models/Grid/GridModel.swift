//
//  GridModel.swift
//  Slider
//
//  Created by Tom Nelson on 10/12/16.
//  Copyright © 2016 TKO Solutions. All rights reserved.
//

import UIKit

class GridModel {
  
  private var currentGrid: [[Int]]!
  
  private var zeroMoveBoard: [[Int]]!
  private var oneMoveBoard: [[Int]]?
  private var twoMoveBoard: [[Int]]?
  
  private var gridBlocks = [BlockModel]()
  
  private var oneMoveBlocks = [Int]()
  private var twoMoveBlocks = [Int]()
  private var movingBlocks = [Int]()
  
  private var gameLogic = GridModelLogic()
  private var direction: Direction?
  private var notThisDirection: Direction?
  private var board: Board = .moveOneSpace
  
  var start: UILabel!
  var finish: UILabel!
  var twoMove: UILabel!
  
  var gameViewModelUpdateUI: (() -> ()) = { _ in }

  var blockCount: Int {
    return gridBlocks.count
  }
  
  func block(_ index: Int) -> BlockModel? {
    guard index >= 0 && index < gridBlocks.count else { return nil }
    
    return gridBlocks[index]
  }
  
  func allBlocks() -> [BlockModel] {
    return gridBlocks
  }

  init(_ grid: [[Int]]) {
    self.currentGrid = grid
    gridBlocks = GridModelInitialization().initBlocks(grid: grid)
    for block in gridBlocks { setClosures(block) }
  }
  
  private func setClosures(_ block: BlockModel) {
    block.blockModelUpdateGrid = { board in
      self.updateGrid(board)
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
  
  func updateGrid(_ board: Board) {
    print("updateGrid \(board)")
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
      if let dir = gameLogic.setDirection(x: amount.x, y: amount.y) {
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
    updateGridForFinishPosition(board)
    updateBlockOriginsForBoard(currentGrid)
    resetBlocks()
    gameViewModelUpdateUI()
  }

  private func updateGridForFinishPosition(_ board: Board) {
    print("update Grid For Finish Position \(board) *******")
    switch board {
    case .moveZeroSpaces: currentGrid = zeroMoveBoard
    case .moveOneSpace: currentGrid = oneMoveBoard
    case .moveTwoSpaces: currentGrid = twoMoveBoard
    }
    
    oneMoveBoard = nil
    twoMoveBoard = nil
  }
  
  private func updateBlockOriginsForBoard(_ grid: [[Int]]) {
    for row in (0..<Rows).reversed() {
      for col in (0..<Columns).reversed() {
        gridBlocks[grid[row][col]].origin = Coordinate(row: row, col: col)
      }
    }
  }
  
  private func resetBlocks() {
    print("resetting double move legal and in double move to false for all blocks")
    for block in gridBlocks {
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
    
    start.text =  GridModelUtility.showBoard(board: .moveZeroSpaces, grid: currentGrid)
    finish.text = GridModelUtility.showBoard(board: .moveOneSpace, grid: oneMoveBoard)
    twoMove.text = GridModelUtility.showBoard(board: .moveTwoSpaces, grid: twoMoveBoard)
    setMinMaxMove(direction)
    return true
  }

  private func setMinMaxMove(_ direction: Direction) {
    for block in gridBlocks {
      block.setMinMaxMove(direction)
    }
  }
  
  // Set the three grids, zero, one and two moveGrid
  private func setOutcomesForMove(_ direction: Direction, _ index: Int) -> Bool {
    guard self.direction == nil else { return true }
    guard notThisDirection != direction else { return false }

    print("setOutcomesForMove block \(index) \(direction)")
    
    zeroMoveBoard = currentGrid
    
    guard let oneMoveBoard = gameLogic.newGridForMove(zeroMoveBoard, index, direction)
      else { return false}
    self.oneMoveBoard = oneMoveBoard
    oneMoveBlocks = gameLogic.blocksThatMoved(startGrid: zeroMoveBoard, endGrid: oneMoveBoard)
    movingBlocks = oneMoveBlocks
    print("oneMoveBlocks \(oneMoveBlocks)")
    
    guard let twoMoveBoard = gameLogic.newGridForMove(oneMoveBoard, index, direction)
      else { return true }
    self.twoMoveBoard = twoMoveBoard
    twoMoveBlocks = gameLogic.blocksThatMoved(startGrid: oneMoveBoard, endGrid: twoMoveBoard)
    print("twoMoveBlocks \(twoMoveBlocks)")

    for index in twoMoveBlocks {
      if oneMoveBlocks.contains(index) {
        block(index)?.doubleMoveLegal = true
      }
    }
    
    return true
  }
}
