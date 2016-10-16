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
    guard canMove(direction: direction) else { return }
    viewModel.moveByAmount(direction: direction, amount: amount)
    
    guard let neighbors = neighbors(direction) else { return }
    for neighbor in neighbors {
      neighbor.moveByAmount(direction: direction, amount: amount)
    }
  }
  
  func setFinalPosition(_ direction: Direction) {
    updateOrigin(direction)
    viewModel.placeBlock(point: GridConstants.blockCenter(row: origin.row, col: origin.col, type: type))
    viewModel.updateUI()
    
    guard let neighbors = neighbors(direction) else { return }
    for neighbor in neighbors {
      guard neighbor.index != EmptySpace else { continue }
      neighbor.setFinalPosition(direction)
    }
  }
  
  func updateOrigin(_ direction: Direction) {
    guard index != EmptySpace else { return }
    guard let _ = neighbors(direction) else { return }
    
    switch direction {
    case .up:
      origin.row -= 1
      assert(origin.row >= 0, "row < 0")
    case .down:
      origin.row += 1
      assert(origin.row < Rows, "row > Rows")
    case .left:
      origin.col -= 1
      assert(origin.col >= 0,  "col < 0")
    case .right:
      origin.col += 1
      assert(origin.col < Columns," col > Columns")
    }
    print("updated block \(index!) origin to: (\(origin.row),\(origin.col)))")
  }
  
  var coordinates: String {
    var rtn: String = "\nblock \(index!):\n"
    switch type! {
    case .small:
      rtn += "[\(origin.row),\(origin.col)]"
    case .wide:
      rtn += "[\(origin.row),\(origin.col))] [\(origin.row),\(origin.col)+1)]"
    case .tall:
      rtn += "[\(origin.row),\(origin.col))]\n[\(origin.row+1),\(origin.col))]"
    case .big:
      rtn += "[\(origin.row),\(origin.col))] [\(origin.row),\(origin.col)+1)]\n[\(origin.row+1),\(origin.col))] [\(origin.row+1),\(origin.col)+1)]"
    }
    return rtn
  }

  func resetNeighbors() {
    neighbors = [.up: Set<BlockModel>(), .right: Set<BlockModel>(), .down: Set<BlockModel>(), .left: Set<BlockModel>()]
  }
  
  func neighbors(_ direction: Direction) -> Set<BlockModel>? {
    guard let blocks = neighbors[direction] else { return nil }
    return blocks
  }
  
  func addNeighbor(direction: Direction, block: BlockModel) {
    neighbors[direction]?.insert(block)
  }
  
  func canMove(direction: Direction) -> Bool {
    return blockLogic.canMove(block: self, direction: direction)
  }
  
  func move(_ direction: Direction) {
    if canMove(direction: direction) {
      blockLogic.move(block: self, direction: direction)
    }
  }
}

extension BlockModel: Equatable { }
func == (lhs: BlockModel, rhs: BlockModel) -> Bool {
  return lhs.index == rhs.index
}
