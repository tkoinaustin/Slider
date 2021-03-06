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
  private var direction: Direction?
//    { didSet {
//    if let direction = direction {
//      print("------ direction changed to \(direction)")
//    } else {
//      print("------ direction changed to nil")
//    }
//  }}
  
  weak var viewModel: BlockViewModel!

  var doubleMoveLegal = false
  var inDoubleMove = false
  var board: Board = .moveZeroSpaces
//  { didSet {
//    print("\(index!) board changed to \(board)")
//  }}
  var ppb: CGFloat!  // pixels per block, ie, how far a block can travel in one move
  
  fileprivate var startingCenter = CGPoint(x:0, y:0)
  fileprivate var currentOffset = CGPoint(x:0, y:0)
  fileprivate var minOffset = CGPoint(x:0, y:0)
  fileprivate var maxOffset = CGPoint(x:0, y:0)
  
  var hashValue: Int {
    return index
  }

  var blockModelUpdateGrid: ((Board) -> Void) = {_ in }
  var blockModelBlockMovedBy: ((_: CGPoint, _: Int) -> (Direction?)) = { _, _ in return nil}
  var blockModelMoveFinished: (() -> Void) = { }

  init(index: Int) {
    self.index = index
  }
  
  init(model: BlockModel) {
    index = model.index!
    type = model.type!
    origin = model.origin
  }
  
  func blockMovedBy(_ amount: CGPoint) {
    if let direction = blockModelBlockMovedBy(amount, index) {
      checkForDoubleMoveChange(direction)
    }
  }
  
  func moveBy(_ amount: CGPoint, _ direction: Direction) {
    updateCurrentOffset(direction, amount)
    viewModel.setCenter(newCenter: currentOffset)
  }
  
  // swiftlint:disable function_body_length
  func setMinMaxMove(_ direction: Direction) {
    // swiftlint:enable function_body_length
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
    guard let ppb = ppb else { return }
    var dblMove: Bool?, changedBoard: Board?
    let blockLogic = BlockModelLogic()
    
    switch direction {
    case .up:
      (dblMove, changedBoard) = blockLogic.checkForUpGameboardChange(
        currentOffset, startingCenter, board, doubleMoveLegal, ppb
      )
    case .down:
      (dblMove, changedBoard) = blockLogic.checkForDownGameboardChange(
        currentOffset, startingCenter, board, doubleMoveLegal, ppb
      )
    case .left:
      (dblMove, changedBoard) = blockLogic.checkForLeftGameboardChange(
        currentOffset, startingCenter, board, doubleMoveLegal, ppb
      )
    case .right:
      (dblMove, changedBoard) = blockLogic.checkForRightGameboardChange(
        currentOffset, startingCenter, board, doubleMoveLegal, ppb
      )
    }
    
    if let dblMove = dblMove { inDoubleMove = dblMove }
    
    if let changedBoard = changedBoard {
      board = changedBoard
      
      blockModelUpdateGrid(changedBoard)
    }
  }
  
  private func updateCurrentOffset(_ direction: Direction, _ amount: CGPoint) {
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
  
  private func updateOrigin(_ direction: Direction) {
    guard index != emptySpace else { return }
    
    switch direction {
    case .up:
      origin.row -= 1
      assert(origin.row >= 0, "row < 0")
    case .down:
      origin.row += 1
      assert(origin.row < Rows, "row > Rows")
    case .left:
      origin.col -= 1
      assert(origin.col >= 0, "col < 0")
    case .right:
      origin.col += 1
      assert(origin.col < Columns, " col > Columns")
    }
//    print("BlockModel updated block \(index!) origin to: (\(origin.row),\(origin.col))")
  }

}

extension BlockModel: Equatable { }
func == (lhs: BlockModel, rhs: BlockModel) -> Bool {
  return lhs.index == rhs.index
}
