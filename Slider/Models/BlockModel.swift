//
//  BlockModel.swift
//  Slider
//
//  Created by Tom Nelson on 10/13/16.
//  Copyright © 2016 TKO Solutions. All rights reserved.
//

import UIKit

class BlockModel: Hashable {
  
  var index: Int!
  var type: BlockType!
  var origin = Coordinate(row:0, col:0)
  private var neighbors: [Direction: Set<BlockModel>]!
  private var blockLogic = BlockModelLogic()

  init(index: Int) {
    self.index = index
    resetNeighbors()
  }
  
  var hashValue: Int {
    return index
  }
  
//   this needs to be moved to the Model classes
//  func canMove(direction: Direction) -> Bool {
//    guard let blocks = neighbors[direction] else { print("guard failed"); return false }
//    if blocks.count == 0 { print("no neighbors"); return false }
//    
//    for block in blocks {
//      if block.index == EmptySpace {
//        print("empty space")
//        /* move legal, check other blocks */
//      } else if !block.canMove(direction: direction) {
//        print("checking block \(block.index)")
//        return false
//      }
//    }
//    
//    return true
//  }
  
 
  func resetNeighbors() {
    neighbors = [.up: Set<BlockModel>(), .right: Set<BlockModel>(), .down: Set<BlockModel>(), .left: Set<BlockModel>()]
  }
  
  func neighbors(direction: Direction) -> Set<BlockModel>? {
    guard let blocks = neighbors[direction] else { return nil }
    return blocks
  }

  func canMove(direction: Direction) -> Bool {
    return blockLogic.canMove(block: self, direction: direction)
  }
  
  func addNeighbor(direction: Direction, block: BlockModel) {
    neighbors[direction]?.insert(block)
  }
  
  func updateForDirection(direction: Direction) {
    if canMove(direction: direction) {
      blockLogic.move(block: self, direction: direction)
    }
  }
}

extension BlockModel: Equatable { }
func == (lhs: BlockModel, rhs: BlockModel) -> Bool {
  return lhs.index == rhs.index
}
