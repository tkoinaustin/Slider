//
//  Constants.swift
//  Slider
//
//  Created by Tom Nelson on 10/8/16.
//  Copyright © 2016 TKO Solutions. All rights reserved.
//

import UIKit

let emptySpace = 0

class GridConstants {
  // swiftlint:disable comma
  static let blankLayout = [[0,0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0]]
  // swiftlint:enable comma

  static private let colCenters: [CGFloat] = [0.125, 0.375, 0.625, 0.875]
  static private let rowCenters: [CGFloat] = [0.1, 0.3, 0.5, 0.7, 0.9]
  
  static func blockCenter(row: Int, col: Int, type: BlockType) -> CGPoint {
    var xCol = colCenters[col]
    var yRow = rowCenters[row]
    
    switch type {
    case .small:
      break
    case .wide:
      xCol += 0.125
    case .tall:
      yRow += 0.1
    case .big:
      xCol += 0.125
      yRow += 0.1
    }
    return CGPoint(x: xCol, y: yRow)
  }
}
