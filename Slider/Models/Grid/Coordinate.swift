//
//  Coordinate.swift
//  Slider
//
//  Created by Tom Nelson on 11/10/16.
//  Copyright © 2016 TKO Solutions. All rights reserved.
//

import UIKit

enum Board {
  case moveZeroSpaces, moveOneSpace, moveTwoSpaces
}

struct Coordinate: Equatable {
  var row: Int
  var col: Int
  
  func move(_ direction: Direction) -> Coordinate? {
    
    switch direction {
    case .up:
      if self.row == 0 { return nil }
      return Coordinate(row:self.row - 1, col:self.col)
    case .down:
      if self.row == Rows - 1 { return nil }
      return Coordinate(row:self.row + 1, col:self.col)
    case .left:
      if self.col == 0 { return nil }
      return Coordinate(row:self.row, col:self.col - 1)
    case .right:
      if self.col == Columns - 1 { return nil }
      return Coordinate(row:self.row, col:self.col + 1)
    }
  }
  
  public static func == (lhs: Coordinate, rhs: Coordinate) -> Bool {
    return lhs.row == rhs.row && lhs.col == rhs.col
  }

}
