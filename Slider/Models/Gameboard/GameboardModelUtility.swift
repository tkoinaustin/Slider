//
//  GameboardModelUtility.swift
//  Slider
//
//  Created by Tom Nelson on 11/10/16.
//  Copyright © 2016 TKO Solutions. All rights reserved.
//

import UIKit

class GameboardModelUtility {
  // throw away code, diagnostics to show grids on main UI for debugging
  static func showBoard(board: Board, grid: [[Int]]?) -> String {
    var msg: String
    switch board {
    case .moveZeroSpaces: msg = "current grid: \n"
    case .moveOneSpace: msg = "single move: \n"
    case .moveTwoSpaces: msg = "double move: \n"
    }
    if let grid = grid { msg += GameboardModelUtility.printGameboard(grid: grid) }
    
    return msg
  }
  
  static private func printGameboard(grid: [[Int]]) -> String {
    var  desc = ""
    for row in 0..<Rows {
      for col in 0..<Columns {
        desc += "[\(grid[row][col])]"// + col == Columns - 1 ? "\n" : ", "
        desc += col == Columns - 1 ? "\n" : ", "
      }
    }
    return desc
  }

}
