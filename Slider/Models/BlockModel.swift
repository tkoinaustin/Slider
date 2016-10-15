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
  weak var viewModel: BlockViewModel!
  private var neighbors: [Direction: Set<BlockModel>]!
  private var blockLogic = BlockModelLogic()

  init(index: Int) {
    self.index = index
    resetNeighbors()
  }
  
  init(model: BlockModel) {
    index = model.index!
    type = model.type!
    origin = model.origin
    resetNeighbors()
  }

  var hashValue: Int {
    return index
  }
  
  func moveByAmount(direction: Direction, amount: CGPoint) {
    viewModel.moveByAmount(direction: direction, amount: amount)
  }
  
  func updateUI() {
    viewModel.updateUI()
  }
 
  func resetNeighbors() {
    neighbors = [.up: Set<BlockModel>(), .right: Set<BlockModel>(), .down: Set<BlockModel>(), .left: Set<BlockModel>()]
  }
  
  func neighbors(_ direction: Direction) -> Set<BlockModel>? {
    guard let blocks = neighbors[direction] else { return nil }
    return blocks
  }

  func canMove(direction: Direction) -> Bool {
    return blockLogic.canMove(block: self, direction: direction)
  }
  
  func addNeighbor(direction: Direction, block: BlockModel) {
    neighbors[direction]?.insert(block)
  }
  
  func updateForDirection(_ direction: Direction) {
    if canMove(direction: direction) {
      blockLogic.move(block: self, direction: direction)
    }
  }
}

extension BlockModel: Equatable { }
func == (lhs: BlockModel, rhs: BlockModel) -> Bool {
  return lhs.index == rhs.index
}
