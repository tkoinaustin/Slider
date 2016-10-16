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
    grid = GameModel(gridLayout)
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
  
  func testResetNeighbors() {
    block = grid.block(9)
    block.resetNeighbors()
    XCTAssertTrue(block.neighbors(.up) == Set<BlockModel>(), "Neighbors should be empty")
    XCTAssertTrue(block.neighbors(.down) == Set<BlockModel>(), "Neighbors should be empty")
    XCTAssertTrue(block.neighbors(.left) == Set<BlockModel>(), "Neighbors should be empty")
    XCTAssertTrue(block.neighbors(.right) == Set<BlockModel>(), "Neighbors should be empty")
  }
  
  //  [2, 2,  3, 4]
  //  [1, 1,  0, 4]
  //  [1, 1,  8, 0]
  //  [5, 7,  9, 11]
  //  [5, 10, 6, 6]
  
  func testMove() {
    block = grid.block(8)
    block.move(.up)
    XCTAssertTrue(block.origin.row == 1, "block 8 did not move up")
  }
  
  func testMove1() {
    block = grid.block(6)
    block.move(.up)
    XCTAssertTrue(block.origin.row == 3, "block 6 did not move up")
    XCTAssertTrue(grid.block(9)?.origin.row == 2, "block 9 did not move up")
    XCTAssertTrue(grid.block(11)?.origin.row == 2, "block 11 did not move up")
    XCTAssertTrue(grid.block(8)?.origin.row == 1, "block 8 did not move up")
  }
}
