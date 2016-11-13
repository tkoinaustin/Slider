//
//  BlockModelLogic.swift
//  Slider
//
//  Created by Tom Nelson on 10/13/16.
//  Copyright © 2016 TKO Solutions. All rights reserved.
//

import UIKit

class BlockModelLogic {
  // swiftlint:disable variable_name
  func setDirection(x: CGFloat, y: CGFloat) -> Direction? {
    // swiftlint:enable variable_name
    let threshhold: CGFloat = 2
    guard abs(x) > threshhold || abs(y) > threshhold else { return nil }
    if abs(x) > abs(y) {
      return x > 0 ? .right : .left
    } else {
      return y > 0 ? .down : .up
    }
  }

  func checkForUpGameboardChange(_ currentOffset: CGPoint,
                                 _ startingCenter: CGPoint,
                                 _ board: Board,
                                 _ doubleMoveLegal: Bool,
                                 _ ppb: CGFloat) -> (Bool?, Board?) {
    var dblMove: Bool?, changedBoard: Board?
    
    if doubleMoveLegal && currentOffset.y <= startingCenter.y - ppb && board != .moveTwoSpaces {
      dblMove = true
      changedBoard = .moveTwoSpaces
    }
    if currentOffset.y >= startingCenter.y - ppb && board == .moveTwoSpaces {
      dblMove = false
      changedBoard = .moveOneSpace
    }
    if currentOffset.y >= startingCenter.y && board == .moveOneSpace {
      changedBoard = .moveZeroSpaces
    }
    if currentOffset.y < startingCenter.y && board == .moveZeroSpaces {
      changedBoard = .moveOneSpace
    }

    return (dblMove, changedBoard)
  }
  
  func checkForDownGameboardChange(_ currentOffset: CGPoint,
                                   _ startingCenter: CGPoint,
                                   _ board: Board,
                                   _ doubleMoveLegal: Bool,
                                   _ ppb: CGFloat) -> (Bool?, Board?) {
    var dblMove: Bool?, changedBoard: Board?
    
    if doubleMoveLegal && currentOffset.y >= startingCenter.y + ppb && board != .moveTwoSpaces {
      dblMove = true
      changedBoard = .moveTwoSpaces
    }
    if currentOffset.y <= startingCenter.y + ppb && board == .moveTwoSpaces {
      dblMove = false
      changedBoard = .moveOneSpace
    }
    if currentOffset.y <= startingCenter.y && board == .moveOneSpace {
      changedBoard = .moveZeroSpaces
    }
    if currentOffset.y > startingCenter.y && board == .moveZeroSpaces {
      changedBoard = .moveOneSpace
    }

    return (dblMove, changedBoard)
  }
  
  func checkForLeftGameboardChange(_ currentOffset: CGPoint,
                                   _ startingCenter: CGPoint,
                                   _ board: Board,
                                   _ doubleMoveLegal: Bool,
                                   _ ppb: CGFloat) -> (Bool?, Board?) {
    var dblMove: Bool?, changedBoard: Board?
    
    if doubleMoveLegal && currentOffset.x <= startingCenter.x - ppb && board != .moveTwoSpaces {
      dblMove = true
      changedBoard = .moveTwoSpaces
    }
    if currentOffset.x >= startingCenter.x - ppb && board == .moveTwoSpaces {
      dblMove = false
      changedBoard = .moveOneSpace
    }
    if currentOffset.x >= startingCenter.x && board == .moveOneSpace {
      changedBoard = .moveZeroSpaces
    }
    if currentOffset.x < startingCenter.x && board == .moveZeroSpaces {
      changedBoard = .moveOneSpace
    }
    
    return (dblMove, changedBoard)
  }
  
  func checkForRightGameboardChange(_ currentOffset: CGPoint,
                                    _ startingCenter: CGPoint,
                                    _ board: Board,
                                    _ doubleMoveLegal: Bool,
                                    _ ppb: CGFloat) -> (Bool?, Board?) {
    var dblMove: Bool?, changedBoard: Board?
    
    if doubleMoveLegal && currentOffset.x >= startingCenter.x + ppb && board != .moveTwoSpaces {
      dblMove = true
      changedBoard = .moveTwoSpaces
    }
    if currentOffset.x <= startingCenter.x + ppb && board == .moveTwoSpaces {
      dblMove = false
      changedBoard = .moveOneSpace
    }
    if currentOffset.x <= startingCenter.x && board == .moveOneSpace {
      changedBoard = .moveZeroSpaces
    }
    if currentOffset.x > startingCenter.x && board == .moveZeroSpaces {
      changedBoard = .moveOneSpace
    }
    
    return (dblMove, changedBoard)
  }

}
