//
//  GridViewModel.swift
//  Slider
//
//  Created by Mac Daddy on 9/27/16.
//  Copyright © 2016 TKO Solutions. All rights reserved.
//

import UIKit

let Rows = 5
let Columns = 4

class GridViewModel {
  
  var blocks = [BlockViewModel]()
  
  func initBlocks(grid: [[Int]]) {
    var indices = Set<Int>()
    for row in 0..<Rows {
      for col in 0..<Columns {
        indices.insert(grid[row][col])
      }
    }
    
    blocks.removeAll()
    for index in indices.sorted() {
      blocks.append(BlockViewModel(index: index))
    }
  }
  
  func setNeighbors(grid: [[Int]], blocks: inout [BlockViewModel]) {
    guard blocks.count > 0 else { return }
    
    for row in 0..<Rows {
      for col in 0..<Columns {
        let block = blocks[grid[row][col]]
        if let neighbor = topNeighbor(grid: grid, row: row, col: col) {
          if block.index != EmptySpace && block.index != neighbor.index {
            block.addNeighbor(direction: .up, block: neighbor)
          }
        }
        if let neighbor = bottomNeighbor(grid: grid, row: row, col: col) {
          if block.index != EmptySpace && block.index != neighbor.index {
            block.addNeighbor(direction: .down, block: neighbor)
          }
        }
        if let neighbor = leftNeighbor(grid: grid, row: row, col: col) {
          if block.index != EmptySpace && block.index != neighbor.index {
            block.addNeighbor(direction: .left, block: neighbor)
          }
        }
        if let neighbor = rightNeighbor(grid: grid, row: row, col: col) {
          if block.index != EmptySpace && block.index != neighbor.index {
            block.addNeighbor(direction: .right, block: neighbor)
          }
        }
      }
    }
  }

  func topNeighbor(grid: [[Int]], row: Int, col: Int) -> BlockViewModel? {
    guard row > 0 else { return nil }
    
    let index = grid[row-1][col]
    return blocks[index]
  }
  
  func bottomNeighbor(grid: [[Int]], row: Int, col: Int) -> BlockViewModel? {
    guard row < Rows-1 else { return nil }
    
    let index = grid[row+1][col]
    return blocks[index]
  }
  
  func leftNeighbor(grid: [[Int]], row: Int, col: Int) -> BlockViewModel? {
    guard col > 0 else { return nil }
    
    let index = grid[row][col-1]
    return blocks[index]
  }

  func rightNeighbor(grid: [[Int]], row: Int, col: Int) -> BlockViewModel? {
    guard col < Columns-1 else { return nil }
    
    let index = grid[row][col+1]
    return blocks[index]
  }
}
