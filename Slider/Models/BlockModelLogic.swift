//
//  BlockModelLogic.swift
//  Slider
//
//  Created by Tom Nelson on 10/13/16.
//  Copyright © 2016 TKO Solutions. All rights reserved.
//

import UIKit

class BlockModelLogic {
  
  func canMove(block: BlockModel, direction: Direction) -> Bool {
    guard let blocks = block.neighbors(direction) else { print("guard failed"); return false }
    if blocks.count == 0 {
//      print("no neighbors");
      return false
    }
    
    for block in blocks {
      if block.index == EmptySpace {
//        print("empty space")
        /* move legal, check other blocks */
      } else if !canMove(block: block, direction: direction) {
//        print("checking block \(block.index)")
        return false
      }
    }
//    print("block \(block.index!) can move \(direction)")
    return true
  }

  func move(block: BlockModel, direction: Direction) {
    updateOrigin(block: block, direction: direction)
    guard let neighboringBlocks = block.neighbors(direction) else { return }
    
    for neighbor in neighboringBlocks {
      guard neighbor.index != EmptySpace else { continue }
      move(block: neighbor, direction: direction)
    }
  }
  
  private func updateOrigin(block: BlockModel, direction: Direction) {
    guard block.index != EmptySpace else { return }
    guard let _ = block.neighbors(direction) else { return }
    
    switch direction {
    case .up:
      block.origin.row -= 1
      assert(block.origin.row >= 0, "row < 0")
    case .down:
      block.origin.row += 1
      assert(block.origin.row < Rows, "row > Rows")
    case .left:
      block.origin.col -= 1
      assert(block.origin.col >= 0,  "col < 0")
    case .right:
      block.origin.col += 1
      assert(block.origin.col < Columns," col > Columns")
    }
    print("block \(block.index!) origin: (\(block.origin.row),\(block.origin.col))")
  }
}
