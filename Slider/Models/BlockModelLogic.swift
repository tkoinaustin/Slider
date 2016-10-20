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
      return false
    }
    
    for block in blocks {
      if block.index == EmptySpace {
        /* move legal, check other blocks */
      } else if !canMove(block: block, direction: direction) {
        return false
      }
    }

    return true
  }
  
  
  func setDirection(x: CGFloat, y: CGFloat) -> Direction? {
    let threshhold: CGFloat = 2
    guard abs(x) > threshhold || abs(y) > threshhold else { return nil }
    if abs(x) > abs(y) {
      return x > 0 ? .right : .left
    } else {
      return y > 0 ? .down : .up
    }
  }

  func checkForUpDoubleMove(_ currentOffset: CGPoint, _ startingCenter: CGPoint, _ board: Board, _ inDoubleMove: Bool, _ ppb: CGFloat) -> (Bool?, Board?) {
    var dblMove: Bool?, board: Board?
    
    if currentOffset.y <= startingCenter.y - ppb && board != .moveTwoSpaces {
      dblMove = true
      board = .moveTwoSpaces
    }
    if currentOffset.y >= startingCenter.y - ppb && board == .moveTwoSpaces {
      dblMove = false
      board = .moveOneSpace
    }
    
    return (dblMove, board)
  }
  
  func checkForDownDoubleMove(_ currentOffset: CGPoint, _ startingCenter: CGPoint, _ board: Board, _ inDoubleMove: Bool, _ ppb: CGFloat) -> (Bool?, Board?) {
    var dblMove: Bool?, board: Board?
    
    if currentOffset.y >= startingCenter.y + ppb && board != .moveTwoSpaces {
      dblMove = true
      board = .moveTwoSpaces
    }
    if currentOffset.y <= startingCenter.y + ppb && board == .moveTwoSpaces {
      dblMove = false
      board = .moveOneSpace
    }
    
    return (dblMove, board)
  }
  
  func checkForLeftDoubleMove(_ currentOffset: CGPoint, _ startingCenter: CGPoint, _ board: Board, _ inDoubleMove: Bool, _ ppb: CGFloat) -> (Bool?, Board?) {
    var dblMove: Bool?, board: Board?
    
    if currentOffset.x <= startingCenter.x - ppb && board != .moveTwoSpaces {
      dblMove = true
      board = .moveOneSpace
    }
    if currentOffset.x >= startingCenter.x - ppb && board == .moveTwoSpaces {
      dblMove = false
      board = .moveZeroSpaces
    }
    
    return (dblMove, board)
  }
  
  func checkForRightDoubleMove(_ currentOffset: CGPoint, _ startingCenter: CGPoint, _ board: Board, _ inDoubleMove: Bool, _ ppb: CGFloat) -> (Bool?, Board?) {
    var dblMove: Bool?, board: Board?
    
    if currentOffset.x >= startingCenter.x + ppb && board != .moveTwoSpaces {
      dblMove = true
      board = .moveOneSpace
    }
    if currentOffset.x <= startingCenter.x + ppb && board == .moveTwoSpaces {
      dblMove = false
      board = .moveZeroSpaces
    }
    
    return (dblMove, board)
  }

}
