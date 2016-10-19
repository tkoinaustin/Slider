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
//        print ("block \(block.index)")
        
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
  
  func makeGameboard(blocks: [BlockModel]) -> [[Int]] {
      var gridLayout = GridConstants.blankLayout
    
      for block in blocks {
        gridLayout[block.origin.row][block.origin.col] = block.index
//        print("gridLayout[\(block.origin.row)][\(block.origin.col)] = \(block.index!)")
        
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
