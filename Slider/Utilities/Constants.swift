//
//  Constants.swift
//  Slider
//
//  Created by Tom Nelson on 10/8/16.
//  Copyright © 2016 TKO Solutions. All rights reserved.
//

import UIKit

class GridConstants {
  static let blankLayout = [[0,0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0]]
  
  static private let colCenters:[CGFloat] = [0.125, 0.375, 0.625, 0.875]
  static private let rowCenters:[CGFloat] = [0.1, 0.3, 0.5, 0.7, 0.9]
  
  static func blockCenter(row: Int, col: Int, type: BlockType) -> CGPoint {
    var x = colCenters[col]
    var y = rowCenters[row]
    
    switch type {
    case .small:
      break
    case .wide:
      x += 0.125
    case .tall:
      y += 0.1
    case .big:
      x += 0.125
      y += 0.1
    }
    return CGPoint(x: x, y: y)
  }

}
