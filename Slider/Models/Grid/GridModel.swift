//
//  GridModel.swift
//  Slider
//
//  Created by Tom Nelson on 10/12/16.
//  Copyright © 2016 TKO Solutions. All rights reserved.
//

import UIKit

let winningCoordinates = Coordinate(row:3, col:1)

class GridModel {
  private var gridBlocks = [BlockModel]()

  private(set) var currentGrid: [[Int]]!
  
  private var zeroMoveBoard: [[Int]]!
  private var oneMoveBoard: [[Int]]?
  private var twoMoveBoard: [[Int]]?
  
  private var oneMoveBlocks = [Int]()
  private var twoMoveBlocks = [Int]()
  private var movingBlocks = [Int]()
  
  private var gridLogic = GridModelLogic()
  private var direction: Direction?
  private var notThisDirection: Direction?
  private var board: Board = .moveOneSpace
  
  var updateGameboardUI: (() -> Void) = { }
  var gameModelMoveFinished: ((_: GameMoveData) -> Void) = { move in }
  var onWinning: ((_: Bool) -> Void) = { won in }
  
  var gameWon: Bool = false { didSet { onWinning(gameWon) }}

  var blockCount: Int { return gridBlocks.count }
  
  func block(_ index: Int) -> BlockModel? {
    guard index >= 0 && index < gridBlocks.count else { return nil }
    
    return gridBlocks[index]
  }
  
  func allBlocks() -> [BlockModel] { return gridBlocks }

  init(_ grid: [[Int]]) {
    self.currentGrid = grid
    gridBlocks.removeAll()
    gridBlocks = GridModelInitialization().initBlocks(grid: grid)
    for block in gridBlocks { setClosures(block) }
  }
  
  func releaseBlocks() { gridBlocks.removeAll() }
  
  func setCurrentGrid(_ grid: [[Int]]) {
    currentGrid = grid
    oneMoveBoard = nil
    twoMoveBoard = nil
    notThisDirection = nil
    direction = nil
  }
  
  private func setClosures( _ block: BlockModel) {
    block.blockModelUpdateGrid = { [unowned self] board in
      self.updateGrid(board)
    }
    
    block.blockModelBlockMovedBy = { [unowned self] amount, index -> Direction? in
      return self.moving(amount: amount, index: index)
    }
    
    block.blockModelMoveFinished = { 
      guard self.direction != nil else {
        self.board = .moveOneSpace
        return
      }
      
      if let grid = self.gridForBoard(board: self.board) {
        let gameMoveData = GameMoveData(block: block.index, direction: self.direction, grid: grid)
        self.gameModelMoveFinished(gameMoveData)
      }
      
      self.gridModelMoveFinished(finalBoard: self.board)
      self.direction = nil
      self.board = .moveOneSpace
      self.gameWon = self.gridBlocks[1].origin == winningCoordinates
    }
  }
  
  func updateGrid(_ board: Board) {
    self.board = board
    switch board {
    case .moveTwoSpaces: movingBlocks = twoMoveBlocks
    case .moveOneSpace, .moveZeroSpaces: movingBlocks = oneMoveBlocks
    }
  }
  
  func moving(amount: CGPoint, index: Int) -> Direction? {
    if let direction = direction { // move by amount in direction if direction is set
      moveBy(amount, direction)
      
      return direction
    } else { // set game boards and direction
      if let dir = gridLogic.setDirection(x: amount.x, y: amount.y) {
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
  
  func gridModelMoveFinished(finalBoard board: Board) {
    currentGrid = gridForBoard(board: board)
    updateBlockOriginsForBoard(currentGrid)
    resetBlocks()
    updateGameboardUI()

    oneMoveBoard = nil
    twoMoveBoard = nil
    notThisDirection = nil
}
  
  private func gridForBoard(board: Board) -> [[Int]]? {
    switch board {
    case .moveZeroSpaces: return zeroMoveBoard
    case .moveOneSpace: return oneMoveBoard
    case .moveTwoSpaces: return twoMoveBoard
    }
  }
  
  func updateBlockOriginsForBoard(_ grid: [[Int]]) {
    for row in (0..<Rows).reversed() {
      for col in (0..<Columns).reversed() {
        gridBlocks[grid[row][col]].origin = Coordinate(row: row, col: col)
      }
    }
  }
  
  private func resetBlocks() {
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
    
    print("\(GridModelUtility.showBoard(board: .moveZeroSpaces, grid: currentGrid))")
    print("\(GridModelUtility.showBoard(board: .moveOneSpace, grid: oneMoveBoard))")
    print("\(GridModelUtility.showBoard(board: .moveTwoSpaces, grid: twoMoveBoard))")
    setMinMaxMove(direction)
    return true
  }

  private func setMinMaxMove(_ direction: Direction) {
    for block in gridBlocks {
      block.setMinMaxMove(direction)
    }
  }
  
  private func setOutcomesForMove(_ direction: Direction, _ index: Int) -> Bool {
    guard self.direction == nil else { return true }
    guard notThisDirection != direction else { return false }
    
    zeroMoveBoard = currentGrid
    
    guard let oneMoveBoard = gridLogic.newGridForMove(zeroMoveBoard, index, direction)
      else { return false}
    self.oneMoveBoard = oneMoveBoard
    oneMoveBlocks = gridLogic.blocksThatMoved(startGrid: zeroMoveBoard, endGrid: oneMoveBoard)
    movingBlocks = oneMoveBlocks
    
    guard let twoMoveBoard = gridLogic.newGridForMove(oneMoveBoard, index, direction)
      else { return true }
    self.twoMoveBoard = twoMoveBoard
    twoMoveBlocks = gridLogic.blocksThatMoved(startGrid: oneMoveBoard, endGrid: twoMoveBoard)

    for index in twoMoveBlocks {
      if oneMoveBlocks.contains(index) { block(index)?.doubleMoveLegal = true }
    }
    
    return true
  }
}
