//
//  BlockModelLogicTests.swift
//  Slider
//
//  Created by Tom Nelson on 10/14/16.
//  Copyright © 2016 TKO Solutions. All rights reserved.
//

import XCTest
@testable import Slider

class BlockModelLogicTests: XCTestCase {
    
  // swiftlint:disable comma
  let gridLayout = [[2,2,3,4],[1,1,0,4],[1,1,8,0],[5,7,9,11],[5,10,6,6]]
  // swiftlint:enable comma
  var grid: GridModel!
  var block: BlockModel!
  let logic = BlockModelLogic()
  
  override func setUp() {
    super.setUp()
    grid = GridModel(gridLayout)
  }
  
  //  [2, 2,  3, 4]
  //  [1, 1,  0, 4]
  //  [1, 1,  8, 0]
  //  [5, 7,  9, 11]
  //  [5, 10, 6, 6]
}
