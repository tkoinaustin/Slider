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
    
    for idx in 0..<game.blockCount {
      XCTAssertEqual(idx, game.block(idx)?.index,
                     "Block \(String(describing: game.block(idx)?.index)) not in correct order, it is at index \(idx)")
    }
  }
  
}
