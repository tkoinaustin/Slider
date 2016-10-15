//
//  GameModelLogic.swift
//  Slider
//
//  Created by Tom Nelson on 10/13/16.
//  Copyright © 2016 TKO Solutions. All rights reserved.
//

import UIKit

class GameModelLogic {
  
  
  func setNeighbors(grid: [[Int]], blocks: [BlockModel]) {
    guard blocks.count > 0 else { return }
    
    for block in blocks { block.resetNeighbors() }
    
    for row in 0..<Rows {
      for col in 0..<Columns {
        let block = blocks[grid[row][col]]
        print ("block \(block.index)")
        
        if let neighbor = topNeighbor(grid: grid, blocks: blocks, row: row, col: col) {
          if block.index != EmptySpace && block.index != neighbor.index {
            block.addNeighbor(direction: .up, block: neighbor)
          }
        }
        if let neighbor = bottomNeighbor(grid: grid, blocks: blocks, row: row, col: col) {
          if block.index != EmptySpace && block.index != neighbor.index {
            block.addNeighbor(direction: .down, block: neighbor)
            
          }
        }
        if let neighbor = leftNeighbor(grid: grid, blocks: blocks, row: row, col: col) {
          if block.index != EmptySpace && block.index != neighbor.index {
            block.addNeighbor(direction: .left, block: neighbor)
          }
        }
        if let neighbor = rightNeighbor(grid: grid, blocks: blocks, row: row, col: col) {
          if block.index != EmptySpace && block.index != neighbor.index {
            block.addNeighbor(direction: .right, block: neighbor)
          }
        }
      }
    }
  }
  
  private func topNeighbor(grid: [[Int]], blocks: [BlockModel], row: Int, col: Int) -> BlockModel? {
    guard row > 0 else { return nil }
    
    let index = grid[row-1][col]
    return blocks[index]
  }
  
  private func bottomNeighbor(grid: [[Int]], blocks: [BlockModel], row: Int, col: Int) -> BlockModel? {
    guard row < Rows-1 else { return nil }
    
    let index = grid[row+1][col]
    return blocks[index]
  }
  
  private func leftNeighbor(grid: [[Int]], blocks: [BlockModel], row: Int, col: Int) -> BlockModel? {
    guard col > 0 else { return nil }
    
    let index = grid[row][col-1]
    return blocks[index]
  }
  
  private func rightNeighbor(grid: [[Int]], blocks: [BlockModel], row: Int, col: Int) -> BlockModel? {
    guard col < Columns-1 else { return nil }
    
    let index = grid[row][col+1]
    return blocks[index]
  }
 
  private func leadingEdges(block: BlockModel,
                            direction: Direction,
                            coordinate: Coordinate) -> [Coordinate]? {
    let row = coordinate.row
    let col = coordinate.col
    
    switch (direction, block.type!) {
    case (.up, .small),(.up, .tall): return [coordinate]
    case (.up, .wide),(.up, .big): return [coordinate, Coordinate(row: row, col: col+1)]
      
    case (.down, .small): return [coordinate]
    case (.down, .tall): return [Coordinate(row: row+1, col: col)]
    case (.down, .wide): return [coordinate, Coordinate(row: row, col: col+1)]
    case (.down, .big): return [ Coordinate(row: row+1, col: col), Coordinate(row: row+1, col: col+1)]
      
    case (.left, .small),(.left, .wide): return [coordinate]
    case (.left, .tall),(.left, .big): return [coordinate, Coordinate(row: row+1, col: col)]
      
    case (.right, .small): return [coordinate]
    case (.right, .wide): return [Coordinate(row: row, col: col+1)]
    case (.right, .tall): return [coordinate, Coordinate(row: row+1, col: col)]
    case (.right, .big): return [ Coordinate(row: row, col: col+1), Coordinate(row: row+1, col: col+1)]
    }
  }
 
  func rebuildGrid(grid: [[Int]], blocks: [BlockModel]) -> [[Int]] {
      var gridLayout = GridConstants.blankLayout
    
      for block in blocks {
        gridLayout[block.origin.row][block.origin.col] = block.index
        print("gridLayout[\(block.origin.row)][\(block.origin.col)] = \(block.index!)")
        
        switch block.type! {
        case .small:
          continue
        case .wide:
          gridLayout[block.origin.row][block.origin.col+1] = block.index
        case .tall:
          gridLayout[block.origin.row+1][block.origin.col] = block.index
        case .big:
          gridLayout[block.origin.row][block.origin.col+1] = block.index
          gridLayout[block.origin.row+1][block.origin.col] = block.index
          gridLayout[block.origin.row+1][block.origin.col+1] = block.index
        }
      }
    
    return gridLayout
    }

}
