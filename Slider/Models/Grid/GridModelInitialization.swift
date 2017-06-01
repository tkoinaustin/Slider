//
//  GridModelInitialization.swift
//  Slider
//
//  Created by Tom Nelson on 11/10/16.
//  Copyright © 2016 TKO Solutions. All rights reserved.
//

import UIKit
class GridModelInitialization {
  func initBlocks(grid: [[Int]]) -> [BlockModel] {
    let indices = uniqueIndices(grid)
    
    var blocks = makeBlockArray(indices)
    
    for row in 0..<Rows {
      for col in 0..<Columns {
        let block = blocks[(grid[row][col])]
        if block.type != nil { continue }
        
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
  
  private func uniqueIndices(_ grid: [[Int]]) -> Set<Int> {
    var indices = Set<Int>()
    for row in 0..<Rows {
      for col in 0..<Columns {
        indices.insert(grid[row][col])
      }
    }
    
    return indices
  }
  
  private func makeBlockArray(_ indices: Set<Int>) -> [BlockModel] {
    var blocks = [BlockModel]()
    for index in indices.sorted() {
      blocks.append(BlockModel(index: index))
    }
    
    return blocks
  }
}
