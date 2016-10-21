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
    var dblMove: Bool?, changedBoard: Board?
    
    if currentOffset.y <= startingCenter.y - ppb && board != .moveTwoSpaces {
      dblMove = true
      changedBoard = .moveTwoSpaces
    }
    if currentOffset.y >= startingCenter.y - ppb && board == .moveTwoSpaces {
      dblMove = false
      changedBoard = .moveOneSpace
    }
//    if currentOffset.y >= startingCenter.y && board == .moveOneSpace {
//      changedBoard = .moveZeroSpaces
//    }
//    if currentOffset.y < startingCenter.y && board == .moveZeroSpaces {
//      changedBoard = .moveOneSpace
//    }

    return (dblMove, changedBoard)
  }
  
  func checkForDownDoubleMove(_ currentOffset: CGPoint, _ startingCenter: CGPoint, _ board: Board, _ inDoubleMove: Bool, _ ppb: CGFloat) -> (Bool?, Board?) {
    var dblMove: Bool?, changedBoard: Board?
    
    if currentOffset.y >= startingCenter.y + ppb && board != .moveTwoSpaces {
      dblMove = true
      changedBoard = .moveTwoSpaces
    }
    if currentOffset.y <= startingCenter.y + ppb && board == .moveTwoSpaces {
      dblMove = false
      changedBoard = .moveOneSpace
    }
//    if currentOffset.y <= startingCenter.y && board == .moveOneSpace {
//      changedBoard = .moveZeroSpaces
//    }
//    if currentOffset.y > startingCenter.y && board == .moveZeroSpaces {
//      changedBoard = .moveOneSpace
//    }

    return (dblMove, changedBoard)
  }
  
  func checkForLeftDoubleMove(_ currentOffset: CGPoint, _ startingCenter: CGPoint, _ board: Board, _ inDoubleMove: Bool, _ ppb: CGFloat) -> (Bool?, Board?) {
    var dblMove: Bool?, changedBoard: Board?
    
    if currentOffset.x <= startingCenter.x - ppb && board != .moveTwoSpaces {
      dblMove = true
      changedBoard = .moveOneSpace
    }
    if currentOffset.x >= startingCenter.x - ppb && board == .moveTwoSpaces {
      dblMove = false
      changedBoard = .moveZeroSpaces
    }
    
    return (dblMove, changedBoard)
  }
  
  func checkForRightDoubleMove(_ currentOffset: CGPoint, _ startingCenter: CGPoint, _ board: Board, _ inDoubleMove: Bool, _ ppb: CGFloat) -> (Bool?, Board?) {
    var dblMove: Bool?, changedBoard: Board?
    
    if currentOffset.x >= startingCenter.x + ppb && board != .moveTwoSpaces {
      dblMove = true
      changedBoard = .moveOneSpace
    }
    if currentOffset.x <= startingCenter.x + ppb && board == .moveTwoSpaces {
      dblMove = false
      changedBoard = .moveZeroSpaces
    }
    
    return (dblMove, changedBoard)
  }

}
