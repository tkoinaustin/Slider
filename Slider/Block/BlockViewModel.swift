//
//  BlockViewModel.swift
//  Slider
//
//  Created by Mac Daddy on 9/27/16.
//  Copyright © 2016 TKO Solutions. All rights reserved.
//

import UIKit

enum Direction {
  case up, right, down, left
}

let EmptySpace = 0

class BlockViewModel: Hashable {
  var index: Int!
  var neighbors: [Direction: Set<BlockViewModel>] = [.up: Set<BlockViewModel>(), .right: Set<BlockViewModel>(), .down: Set<BlockViewModel>(), .left: Set<BlockViewModel>()]
  
  init(index: Int){
    self.index = index
  }
  
  var hashValue: Int {
    return index
  }
  
  func resetNeighbors() {
    neighbors = [.up: Set<BlockViewModel>(), .right: Set<BlockViewModel>(), .down: Set<BlockViewModel>(), .left: Set<BlockViewModel>()]
  }
  
  func neighbors(direction: Direction) -> Set<BlockViewModel>? {
    guard let blocks = neighbors[direction] else { return nil }
    return blocks
  }
  
  func canMove(direction: Direction) -> Bool {
    guard let blocks = neighbors[direction] else { return false }
    
    for block in blocks {
      if index == EmptySpace { /* move legal, check other blocks */ }
      else if !block.canMove(direction: direction) {return false }
    }
    
    return true
  }
  
  func addNeighbor(direction: Direction, block: BlockViewModel) {
    neighbors[direction]?.insert(block)
  }
  
  func addTopNeighbor(block: BlockViewModel) {
    neighbors[.up]?.insert(block)
  }
  
  func addBottomNeighbor(block: BlockViewModel) {
    neighbors[.down]?.insert(block)
  }

  func addLeftNeighbor(block: BlockViewModel) {
    neighbors[.left]?.insert(block)
  }

  func addRightNeighbor(block: BlockViewModel) {
    neighbors[.right]?.insert(block)
  }

}

extension BlockViewModel: Equatable { }
func == (lhs: BlockViewModel, rhs: BlockViewModel) -> Bool {
  return lhs.index == rhs.index
}
