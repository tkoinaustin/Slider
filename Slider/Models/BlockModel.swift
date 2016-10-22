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
  private var direction: Direction? { didSet {
    if let direction = direction {
      print("------ direction changed to \(direction)")
    } else {
      print("------ direction changed to nil")
    }
    }}
  weak var viewModel: BlockViewModel!

  var doubleMoveLegal = false
  var inDoubleMove = false
  var board: Board = .moveZeroSpaces { didSet {
    print("\(index!) board changed to \(board)")
  }}
  var ppb: CGFloat!  // pixels per block, ie, how far a block can travel in one move
  
  var startingCenter = CGPoint(x:0, y:0)
  var currentOffset = CGPoint(x:0, y:0)
  var minOffset = CGPoint(x:0, y:0)
  var maxOffset = CGPoint(x:0, y:0)
  
  private var neighbors: [Direction: Set<BlockModel>]!
  private var blockLogic = BlockModelLogic()

  var moveFinished: ((Board) -> ()) = {_ in }
  var changeNeighborhood: ((Board) -> ()) = {_ in }
  var setGameplayForDirection: ((_: Direction, _: Int) -> ()) = {_,_ in }

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
  
  func moving(amount: CGPoint) {
    if let direction = direction {
      moveBy(amount, direction)
    } else {
      if let dir = blockLogic.setDirection(x: amount.x, y: amount.y){
        guard canMove(direction: dir) else { return }
        
        self.direction = dir
        setGameplayForDirection(dir, self.index!)
      }
    }
  }

  func moveBy(_ amount: CGPoint,_ direction: Direction) {
    guard canMove(direction: direction) else { return }
    
    updateCurrentOffset(direction, amount)
    viewModel.setCenter(newCenter: currentOffset)

    guard let neighbors = neighbors(direction) else { return }
    for neighbor in neighbors {
      neighbor.moveBy(amount, direction)
    }
    
    checkForDoubleMoveChange(direction)
  }
  
  func finished() {
    guard let direction = direction else {
      print("in finished and direction is nil ****************")
      return
    }
    print("------ finished direction is \(direction)")

    if canMove(direction: direction) {
      setFinalPosition(direction)
    }
    self.direction = nil
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
    updateOrigin(direction)
    guard let neighboringBlocks = neighbors(direction) else { return }
    
    for neighbor in neighboringBlocks {
      guard neighbor.index != EmptySpace else { continue }
      neighbor.move(direction)
    }
  }
  
  func setMinMaxMove(_ direction: Direction) {
    var center = viewModel.center!
    currentOffset = center
    startingCenter = center
    
    let allowedMovement: CGFloat = doubleMoveLegal ? 2 * ppb : ppb
    
    switch direction {
    case .up:
      maxOffset = center
      center.y -= allowedMovement
      minOffset = center
    case .down:
      minOffset = center
      center.y += allowedMovement
      maxOffset = center
    case .left:
      maxOffset = center
      center.x -= allowedMovement
      minOffset = center
    case .right:
      minOffset = center
      center.x += allowedMovement
      maxOffset = center
    }
  }
  
  private func checkForDoubleMoveChange(_ direction: Direction) {
    if !doubleMoveLegal { return }
    guard let ppb = ppb else { return }
    var dblMove: Bool?, changedBoard: Board?
    
    switch direction {
    case .up:
      (dblMove, changedBoard) = blockLogic.checkForUpDoubleMove(currentOffset, startingCenter, board, inDoubleMove, ppb)
    case .down:
      (dblMove, changedBoard) = blockLogic.checkForDownDoubleMove(currentOffset, startingCenter, board, inDoubleMove, ppb)
    case .left:
      (dblMove, changedBoard) = blockLogic.checkForLeftDoubleMove(currentOffset, startingCenter, board, inDoubleMove, ppb)
    case .right:
      (dblMove, changedBoard) = blockLogic.checkForRightDoubleMove(currentOffset, startingCenter, board, inDoubleMove, ppb)
    }
    
    if let dblMove = dblMove { inDoubleMove = dblMove }
    
    if let changedBoard = changedBoard {
      print("\(direction) changeNeighborhood: \(changedBoard)")
      board = changedBoard
      
      //      guard changedBoard != .moveTwoSpaces else { return }
      changeNeighborhood(changedBoard)
    }
  }
  
  private func updateCurrentOffset(_ direction: Direction, _ amount: CGPoint) {
    // here we need to check if we switched to a double move
    switch direction {
    case .up, .down:
      currentOffset.y += amount.y
      currentOffset.y = min(currentOffset.y, maxOffset.y)
      currentOffset.y = max(currentOffset.y, minOffset.y)
    case .left, .right:
      currentOffset.x += amount.x
      currentOffset.x = min(currentOffset.x, maxOffset.x)
      currentOffset.x = max(currentOffset.x, minOffset.x)
    }
  }
  
  // need to figure out how in double move gets set when double move legal is false
  private func setFinalPosition(_ direction: Direction) {
    print("---- set Final Position \(board)")
//    moveFinished(board)
    moveFinished(inDoubleMove && doubleMoveLegal ? .moveTwoSpaces : .moveOneSpace)
    viewModel.updateUI()
  }
  
  private func updateOrigin(_ direction: Direction) {
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
    print("BlockModel updated block \(index!) origin to: (\(origin.row),\(origin.col))")
  }

}

extension BlockModel: Equatable { }
func == (lhs: BlockModel, rhs: BlockModel) -> Bool {
  return lhs.index == rhs.index
}
