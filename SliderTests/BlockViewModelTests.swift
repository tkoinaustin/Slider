//
//  BlockViewModelTests.swift
//  Slider
//
//  Created by Tom Nelson on 9/30/16.
//  Copyright © 2016 TKO Solutions. All rights reserved.
//

import XCTest
@testable import Slider

class BlockViewModelTests: XCTestCase {
  
  let gridLayout = [[2,2,3,4],[1,1,0,4],[1,1,8,0],[5,7,9,11],[5,10,6,6]]
  let game = GameViewModel()
  var block: BlockViewModel!
  
  func testInitBlocks() {
    let game = GameModel(gridLayout)
    XCTAssertTrue(game.blockCount > 0, "Blocks were not initialized")
  }

    override func setUp() {
      super.setUp()
      game.load(gameboard: gridLayout, size: CGSize.zero)
    }
  
  //  [2, 2,  3, 4]
  //  [1, 1,  0, 4]
  //  [1, 1,  8, 0]
  //  [5, 7,  9, 11]
  //  [5, 10, 6, 6]
  
  func testBlockCanMove() {
    var block = game.block(1)
    XCTAssertTrue(block.model.canMove(direction: .right), "Block 1 should be able to not move right")
    XCTAssertFalse(block.model.canMove(direction: .up), "Block 1 should not be able to move up")
    XCTAssertFalse(block.model.canMove(direction: .down), "Block 1 should not be able to move down")
    XCTAssertFalse(block.model.canMove(direction: .left), "Block 1 should not be able to move left")

    block = game.block(8)
    XCTAssertTrue(block.model.canMove(direction: .right), "Block 8 should be able to not move right")
    XCTAssertTrue(block.model.canMove(direction: .up), "Block 8 should be able to move up")
    XCTAssertFalse(block.model.canMove(direction: .down), "Block 8 should not be able to move down")
    XCTAssertFalse(block.model.canMove(direction: .left), "Block 8 should not be able to move left")

    block = game.block(6)
    XCTAssertFalse(block.model.canMove(direction: .right), "Block 6 should not be able to not move right")
    XCTAssertTrue(block.model.canMove(direction: .up), "Block 6 should be able to move up")
    XCTAssertFalse(block.model.canMove(direction: .down), "Block 6 should not be able to move down")
    XCTAssertFalse(block.model.canMove(direction: .left), "Block 6 should not be able to move left")
  }
}
