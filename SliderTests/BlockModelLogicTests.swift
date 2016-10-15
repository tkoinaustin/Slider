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
    
  
  
  let gridLayout = [[2,2,3,4],[1,1,0,4],[1,1,8,0],[5,7,9,11],[5,10,6,6]]
  var grid: GameModel!
  var block: BlockModel!
  let logic = BlockModelLogic()
  
  override func setUp() {
    super.setUp()
    grid = GameModel(gameBoard: gridLayout)
  }
  
  //  [2, 2,  3, 4]
  //  [1, 1,  0, 4]
  //  [1, 1,  8, 0]
  //  [5, 7,  9, 11]
  //  [5, 10, 6, 6]
 
  
  func testCanMove() {
    block = grid.block(5)
    XCTAssertFalse(logic.canMove(block: block, direction: .up), "block 5 should not be able to move up")
    XCTAssertFalse(logic.canMove(block: block, direction: .down), "block 5 should not be able to move down")
    XCTAssertFalse(logic.canMove(block: block, direction: .left), "block 5 should not be able to move left")
    XCTAssertFalse(logic.canMove(block: block, direction: .right), "block 5 should not be able to move right")
    
    block = grid.block(1)
    XCTAssertFalse(logic.canMove(block: block, direction: .up), "block 1 should not be able to move up")
    XCTAssertFalse(logic.canMove(block: block, direction: .down), "block 1 should not be able to move down")
    XCTAssertFalse(logic.canMove(block: block, direction: .left), "block 1 should not be able to move left")
    XCTAssertTrue(logic.canMove(block: block, direction: .right), "block 1 should be able to move right")
    
    block = grid.block(3)
    XCTAssertFalse(logic.canMove(block: block, direction: .up), "block 3 should not be able to move up")
    XCTAssertTrue(logic.canMove(block: block, direction: .down), "block 3 should be able to move down")
    XCTAssertFalse(logic.canMove(block: block, direction: .left), "block 3 should not be able to move left")
    XCTAssertFalse(logic.canMove(block: block, direction: .right), "block 3 should not be able to move right")
    
    block = grid.block(6)
    XCTAssertTrue(logic.canMove(block: block, direction: .up), "block 6 should be able to move up")
    XCTAssertFalse(logic.canMove(block: block, direction: .down), "block 6 should not be able to move down")
    XCTAssertFalse(logic.canMove(block: block, direction: .left), "block 6 should not be able to move left")
    XCTAssertFalse(logic.canMove(block: block, direction: .right), "block 6 should not be able to move right")
  }

}
