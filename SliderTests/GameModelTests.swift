//
//  GameModelTests.swift
//  Slider
//
//  Created by Tom Nelson on 10/13/16.
//  Copyright © 2016 TKO Solutions. All rights reserved.
//

import XCTest
@testable import Slider

class GameModelTests: XCTestCase {
    
  // swiftlint:disable comma
  let gridLayout = [[2,2,3,4],[1,1,0,4],[1,1,8,0],[5,7,9,11],[5,10,6,6]]
  let gridLayout1 = [[2,2,3,0],[1,1,0,4],[1,1,8,4],[5,7,9,11],[5,10,6,6]]
  
  func testInitBlocks() {
    let game = GridModel(gridLayout)
    XCTAssertTrue(game.blockCount > 0, "Blocks were not initialized")
  }
  
  func testBlockOrder() {
    let game = GridModel(gridLayout)
    
    for i in 0..<game.blockCount {
      XCTAssertEqual(i, game.block(i)?.index,
                     "Block \(game.block(i)?.index) not in correct order, it is at index \(i)")
    }
  }
  
}
