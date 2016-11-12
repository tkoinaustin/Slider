//
//  BlockModelTests.swift
//  Slider
//
//  Created by Tom Nelson on 10/13/16.
//  Copyright © 2016 TKO Solutions. All rights reserved.
//

import XCTest
@testable import Slider

class BlockModelTests: XCTestCase {
    
  // swiftlint:disable comma
  let gridLayout = [[2,2,3,4],[1,1,0,4],[1,1,8,0],[5,7,9,11],[5,10,6,6]]
  // swiftlint:enable comma
  var grid: GameModel!
  var block: BlockModel!
  
  override func setUp() {
    super.setUp()
    grid = GameModel(gridLayout)
  }
  
  //  [2, 2,  3, 4]
  //  [1, 1,  0, 4]
  //  [1, 1,  8, 0]
  //  [5, 7,  9, 11]
  //  [5, 10, 6, 6]
}
