//
//  GameMoveData.swift
//  Slider
//
//  Created by Tom Nelson on 11/27/16.
//  Copyright © 2016 TKO Solutions. All rights reserved.
//

import UIKit

class GameMoveData: NSObject, NSCoding {
  var block: Int
  var direction: Direction?
  var grid: [[Int]]
  
  init(block: Int, direction: Direction?, grid: [[Int]]) {
    self.block = block
    self.direction = direction
    self.grid = grid
  }
  
  override init() {
    block = 0
    direction = nil
    grid = [[Int]]()
  }
  
  required convenience init?(coder aDecoder: NSCoder) {
    let block = aDecoder.decodeInteger(forKey: "block")
    let dir = aDecoder.decodeInteger(forKey: "direction")
    let direction = Direction(rawValue: dir)
    guard let grid = aDecoder.decodeObject(forKey: "grid") as? [[Int]] else { return nil }
    self.init(block: block, direction: direction, grid: grid)
  }
  
  func encode(with aCoder: NSCoder) {
    aCoder.encode(block, forKey: "block")
    aCoder.encode(direction!.rawValue, forKey: "direction")
    aCoder.encode(grid, forKey: "grid")
  }
}
