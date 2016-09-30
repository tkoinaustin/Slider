//
//  GridViewModelTests.swift
//  Grid
//
//  Created by Tom Nelson on 9/27/16.
//  Copyright © 2016 Tom Nelson. All rights reserved.
//

import XCTest
@testable import Slider

class GridViewModelTests: XCTestCase {
  
  let gridLayout = [[2,2,3,4],[1,1,0,4],[1,1,8,0],[5,7,9,11],[5,10,6,6]]
  
  func testInit() {
    let grid = GridViewModel()
    XCTAssertNotNil(grid, "Grid object not created")
  }
  
  func testInitBlocks() {
    let grid = GridViewModel()
    grid.initBlocks(grid: gridLayout)
    XCTAssertNotNil(grid.blocks, "Blocks were not initialized")
  }
  
  func testBlockOrder() {
    let grid = GridViewModel()
    grid.initBlocks(grid: gridLayout)
    
    for i in 0..<grid.blocks.count{
      XCTAssertEqual(i, grid.blocks[i].index, "Block \(grid.blocks[i].index) not in correct order, it is at index \(i)")
    }
  }
  
  func testSetNeighbors() {
    let grid = GridViewModel()
    grid.initBlocks(grid: gridLayout)
    grid.setNeighbors(grid: gridLayout, blocks: &grid.blocks)
    let allBlocks = grid.blocks
    
    //  [2, 2,  3, 4]
    //  [1, 1,  0, 4]
    //  [1, 1,  8, 0]
    //  [5, 7,  9, 11]
    //  [5, 10, 6, 6]
    XCTAssertEqual(allBlocks[2].neighbors[.left]?.count, 0, "block 2 should have zero left neighbor")
    XCTAssertEqual(allBlocks[1].neighbors[.left]?.count, 0, "block 1 should have zero left neighbor")
    XCTAssertEqual(allBlocks[6].neighbors[.left]?.count, 1, "block 6 should have one left neighbor")
    XCTAssertEqual(allBlocks[7].neighbors[.left]?.count, 1, "block 7 should have one left neighbor")
    XCTAssertEqual(allBlocks[4].neighbors[.left]?.count, 2, "block 4 should have two left neighbors")
    
    XCTAssertEqual(allBlocks[4].neighbors[.right]?.count, 0, "block 4 should have zero right neighbor")
    XCTAssertEqual(allBlocks[1].neighbors[.right]?.count, 2, "block 1 should have two right neighbors")
    XCTAssertEqual(allBlocks[3].neighbors[.right]?.count, 1, "block 3 should have one right neighbor")
    XCTAssertEqual(allBlocks[5].neighbors[.right]?.count, 2, "block 5 should have two right neighbor")
    XCTAssertEqual(allBlocks[2].neighbors[.right]?.count, 1, "block 2 should have one down neighbor")
    
    XCTAssertEqual(allBlocks[2].neighbors[.up]?.count, 0, "block 2 should have zero top neighbor")
    XCTAssertEqual(allBlocks[1].neighbors[.up]?.count, 1, "block 1 should have one top neighbor")
    XCTAssertEqual(allBlocks[8].neighbors[.up]?.count, 1, "block 8 should have one top neighbor")
    XCTAssertEqual(allBlocks[5].neighbors[.up]?.count, 1, "block 5 should have one top neighbor")
    XCTAssertEqual(allBlocks[6].neighbors[.up]?.count, 2, "block 6 should have two top neighbors")
    
    XCTAssertEqual(allBlocks[5].neighbors[.down]?.count, 0, "block 5 should have zero down neighbor")
    XCTAssertEqual(allBlocks[1].neighbors[.down]?.count, 2, "block 1 should have two down neighbors")
    XCTAssertEqual(allBlocks[11].neighbors[.down]?.count, 1, "block 3 should have one down neighbor")
    XCTAssertEqual(allBlocks[2].neighbors[.down]?.count, 1, "block 2 should have one down neighbor")
  }
}
