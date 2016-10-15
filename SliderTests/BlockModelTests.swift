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
    
  
  let gridLayout = [[2,2,3,4],[1,1,0,4],[1,1,8,0],[5,7,9,11],[5,10,6,6]]
  var grid: GameModel!
  var block: BlockModel!
  
  override func setUp() {
    super.setUp()
    grid = GameModel(gameBoard: gridLayout)
  }
  
  //  [2, 2,  3, 4]
  //  [1, 1,  0, 4]
  //  [1, 1,  8, 0]
  //  [5, 7,  9, 11]
  //  [5, 10, 6, 6]
  func testNeighbors() {
    block = grid.block(9)
    XCTAssert(block.neighbors(.up)! == Set([grid.block(8)!]), "neighbor failed")
    XCTAssert(block.neighbors(.down)! == Set([grid.block(6)!]), "neighbor failed")
    XCTAssert(block.neighbors(.left) == Set([grid.block(7)!]), "neighbor failed")
    XCTAssert(block.neighbors(.right) == Set([grid.block(11)!]), "neighbor failed")
    block = grid.block(1)
    XCTAssert(block.neighbors(.up) == Set([grid.block(2)!]), "neighbor failed")
    XCTAssert(block.neighbors(.down) == Set([grid.block(5)!,grid.block(7)!]), "neighbor failed")
    XCTAssert(block.neighbors(.left) == Set(), "neighbor failed")
    XCTAssert(block.neighbors(.right) == Set([grid.block(0)!,grid.block(8)!]), "neighbor failed")
    block = grid.block(2)
    XCTAssert(block.neighbors(.up) == Set(), "neighbor failed")
    XCTAssert(block.neighbors(.down) == Set([grid.block(1)!]), "neighbor failed")
    XCTAssert(block.neighbors(.left) == Set(), "neighbor failed")
    XCTAssert(block.neighbors(.right) == Set([grid.block(3)!]), "neighbor failed")
  }
  
  func testCanMove() {
    block = grid.block(5)
    XCTAssertFalse(block.canMove(direction: .up), "block 5 should not be able to move up")
    XCTAssertFalse(block.canMove(direction: .down), "block 5 should not be able to move down")
    XCTAssertFalse(block.canMove(direction: .left), "block 5 should not be able to move left")
    XCTAssertFalse(block.canMove(direction: .right), "block 5 should not be able to move right")
    
    block = grid.block(1)
    XCTAssertFalse(block.canMove(direction: .up), "block 1 should not be able to move up")
    XCTAssertFalse(block.canMove(direction: .down), "block 1 should not be able to move down")
    XCTAssertFalse(block.canMove(direction: .left), "block 1 should not be able to move left")
    XCTAssertTrue(block.canMove(direction: .right), "block 1 should be able to move right")
    
    block = grid.block(3)
    XCTAssertFalse(block.canMove(direction: .up), "block 3 should not be able to move up")
    XCTAssertTrue(block.canMove(direction: .down), "block 3 should be able to move down")
    XCTAssertFalse(block.canMove(direction: .left), "block 3 should not be able to move left")
    XCTAssertFalse(block.canMove(direction: .right), "block 3 should not be able to move right")
    
    block = grid.block(6)
    XCTAssertTrue(block.canMove(direction: .up), "block 6 should be able to move up")
    XCTAssertFalse(block.canMove(direction: .down), "block 6 should not be able to move down")
    XCTAssertFalse(block.canMove(direction: .left), "block 6 should not be able to move left")
    XCTAssertFalse(block.canMove(direction: .right), "block 6 should not be able to move right")
  }
  
//  func testFinished() {
//    block = grid.block(4)
//    block.direction = .down
//    block.finished()
//    XCTAssert(block.originRow == 1, "Block 4 didn't move")
//  }
//  
//  func testFinished1() {
//    block = grid.block(6)
//    block.direction = .up
//    block.finished()
//    XCTAssert(block.originRow == 3, "Block 6 didn't move")
//    XCTAssert(grid.block(9).originRow == 2, "Block 9 didn't move")
//    XCTAssert(grid.block(11).originRow == 2, "Block 11 didn't move")
//    XCTAssert(grid.block(8).originRow == 1, "Block 8 didn't move")
//    XCTAssert(grid.block(4).originRow == 0, "Block 4 didn't move")
//  }
}
