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
  let grid = GameViewModel()
  var block: BlockViewModel!

    override func setUp() {
        super.setUp()
      grid.initBlocks(grid: gridLayout)
//      grid.setNeighbors(grid: gridLayout)
    }
  
  //  [2, 2,  3, 4]
  //  [1, 1,  0, 4]
  //  [1, 1,  8, 0]
  //  [5, 7,  9, 11]
  //  [5, 10, 6, 6]
//  func testNeighbors() {
//    block = grid.block(9)
//    XCTAssert(block.neighbors(direction: .up) == Set([grid.block(8)]), "neighbor failed")
//    XCTAssert(block.neighbors(direction: .down) == Set([grid.block(6)]), "neighbor failed")
//    XCTAssert(block.neighbors(direction: .left) == Set([grid.block(7)]), "neighbor failed")
//    XCTAssert(block.neighbors(direction: .right) == Set([grid.block(11)]), "neighbor failed")
//    block = grid.block(1)
//    XCTAssert(block.neighbors(direction: .up) == Set([grid.block(2)]), "neighbor failed")
//    XCTAssert(block.neighbors(direction: .down) == Set([grid.block(5),grid.block(7)]), "neighbor failed")
//    XCTAssert(block.neighbors(direction: .left) == Set(), "neighbor fa iled")
//    XCTAssert(block.neighbors(direction: .right) == Set([grid.block(0),grid.block(8)]), "neighbor failed")
//    block = grid.block(2)
//    XCTAssert(block.neighbors(direction: .up) == Set(), "neighbor failed")
//    XCTAssert(block.neighbors(direction: .down) == Set([grid.block(1)]), "neighbor failed")
//    XCTAssert(block.neighbors(direction: .left) == Set(), "neighbor failed")
//    XCTAssert(block.neighbors(direction: .right) == Set([grid.block(3)]), "neighbor failed")
//  }
//    
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
