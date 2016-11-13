//
//  GameboardModelLogic.swift
//  Slider
//
//  Created by Tom Nelson on 10/13/16.
//  Copyright © 2016 TKO Solutions. All rights reserved.
//

import UIKit

class GameboardModelLogic {
  func blocksThatMoved(startGrid: [[Int]], endGrid: [[Int]]) -> [Int] {
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

  func newGridForMove(_ grid: [[Int]], _ block: Int, _ direction: Direction) -> [[Int]]? {
    var newGrid = grid
    var blockCoords = [Coordinate]()
    
    for row in 0..<Rows {
      for col in 0..<Columns {
        if grid[row][col] == block {
          blockCoords.append(Coordinate(row: row, col: col))
        }
      }
    }
    let startingCoords = findStart(blockCoords, direction)
    
    for coordinate in startingCoords {
      guard let nextNewGrid = move(block, coordinate, direction, replaceWith: 0, grid: newGrid)
        else { return nil }
      newGrid = nextNewGrid
    }
    
    return newGrid
  }
  
  func findStart(_ blocks: [Coordinate], _ direction: Direction) -> [Coordinate] {
    if blocks.count == 1 { return blocks }
    
    var minRow = blocks[0].row
    var maxRow = blocks[0].row
    var minCol = blocks[0].col
    var maxCol = blocks[0].col
    
    for block in blocks {
      minRow = min(minRow, block.row)
      maxRow = max(maxRow, block.row)
      minCol = min(minCol, block.col)
      maxCol = max(maxCol, block.col)
    }
    
    switch direction {
    case .up: return blocks.filter { $0.row == maxRow }
    case .down: return blocks.filter { $0.row == minRow }
    case .left: return blocks.filter { $0.col == maxCol }
    case .right: return blocks.filter { $0.col == minCol }
    }
  }
  
  func move(_ index: Int,
            _ coordinate: Coordinate,
            _ direction: Direction,
            replaceWith: Int,
            grid: [[Int]]) -> [[Int]]? {
    guard let newCoords = coordinate.move(direction) else { return nil }
    
    var newGrid = grid
    let newIndex = grid[newCoords.row][newCoords.col]
    newGrid[coordinate.row][coordinate.col] = replaceWith
    newGrid[newCoords.row][newCoords.col] = index
    
    if newIndex == 0 {
      return newGrid
    }
    
    if let doublewide = coordinateForDoublewide(newCoords, direction, grid) {
      guard let doublewideGrid = move(newIndex,
                                      doublewide,
                                      direction,
                                      replaceWith:0,
                                      grid: newGrid) else { return nil }
      newGrid = doublewideGrid
    }
    
    return move(newIndex, newCoords, direction, replaceWith: index, grid: newGrid)
  }
  
  func coordinateForDoublewide(_ coordinate: Coordinate,
                               _ direction: Direction,
                               _ grid: [[Int]]) -> Coordinate? {
    let index = grid[coordinate.row][coordinate.col]
    
    switch direction {
    case .up, .down:
      var rightBlock: Int?, leftBlock: Int?
      if let rightCoords = coordinate.move(.right) {
        rightBlock = grid[rightCoords.row][rightCoords.col]
        if rightBlock == index { return rightCoords }
      }
      if let leftCoords = coordinate.move(.left) {
        leftBlock = grid[leftCoords.row][leftCoords.col]
        if leftBlock == index { return leftCoords }
      }
    case .left, .right:
      var upBlock: Int?, downBlock: Int?
      if let upCoords = coordinate.move(.up) {
        upBlock = grid[upCoords.row][upCoords.col]
        if upBlock == index { return upCoords }
      }
      if let downCoords = coordinate.move(.down) {
        downBlock = grid[downCoords.row][downCoords.col]
        if downBlock == index { return downCoords }
      }
    }
    
    return nil
  }
  // swiftlint:disable variable_name
  func setDirection(x: CGFloat, y: CGFloat) -> Direction? {
    // swiftlint:enable variable_name
    let threshhold: CGFloat = 2
    guard abs(x) > threshhold || abs(y) > threshhold else { return nil }
    if abs(x) > abs(y) {
      return x > 0 ? .right : .left
    } else {
      return y > 0 ? .down : .up
    }
  }
}
