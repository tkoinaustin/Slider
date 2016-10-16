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
    
  let gridLayout = [[2,2,3,4],[1,1,0,4],[1,1,8,0],[5,7,9,11],[5,10,6,6]]
  let gridLayout1 = [[2,2,3,0],[1,1,0,4],[1,1,8,4],[5,7,9,11],[5,10,6,6]]
  
  func testInitBlocks() {
    let game = GameModel(gridLayout)
    XCTAssertTrue(game.blockCount > 0, "Blocks were not initialized")
  }
  
  func testBlockOrder() {
    let game = GameModel(gridLayout)
    
    for i in 0..<game.blockCount{
      XCTAssertEqual(i, game.block(i)?.index, "Block \(game.block(i)?.index) not in correct order, it is at index \(i)")
    }
  }
  
  func testSetNeighbors() {
    let game = GameModel(gridLayout)
//    grid.setNeighbors(grid: gridLayout)
    
    //  [2, 2,  3, 4]
    //  [1, 1,  0, 4]
    //  [1, 1,  8, 0]
    //  [5, 7,  9, 11]
    //  [5, 10, 6, 6]
    var cnt = game.block(2)?.neighbors(.left)?.count
    XCTAssertEqual(game.block(2)?.neighbors(.left)?.count, 0, "block 2 should have zero left neighbor")
    XCTAssertEqual(game.block(1)?.neighbors(.left)?.count, 0, "block 1 should have zero left neighbor")
    XCTAssertEqual(game.block(6)?.neighbors(.left)?.count, 1, "block 6 should have one left neighbor")
    XCTAssertEqual(game.block(7)?.neighbors(.left)?.count, 1, "block 7 should have one left neighbor")
    XCTAssertEqual(game.block(4)?.neighbors(.left)?.count, 2, "block 4 should have two left neighbors")
    
    XCTAssertEqual(game.block(4)?.neighbors(.right)?.count, 0, "block 4 should have zero right neighbor")
    XCTAssertEqual(game.block(1)?.neighbors(.right)?.count, 2, "block 1 should have two right neighbors")
    XCTAssertEqual(game.block(3)?.neighbors(.right)?.count, 1, "block 3 should have one right neighbor")
    XCTAssertEqual(game.block(5)?.neighbors(.right)?.count, 2, "block 5 should have two right neighbor")
    XCTAssertEqual(game.block(2)?.neighbors(.right)?.count, 1, "block 2 should have one down neighbor")
    
    XCTAssertEqual(game.block(2)?.neighbors(.up)?.count, 0, "block 2 should have zero top neighbor")
    XCTAssertEqual(game.block(1)?.neighbors(.up)?.count, 1, "block 1 should have one top neighbor")
    XCTAssertEqual(game.block(8)?.neighbors(.up)?.count, 1, "block 8 should have one top neighbor")
    XCTAssertEqual(game.block(5)?.neighbors(.up)?.count, 1, "block 5 should have one top neighbor")
    XCTAssertEqual(game.block(6)?.neighbors(.up)?.count, 2, "block 6 should have two top neighbors")
    
    XCTAssertEqual(game.block(5)?.neighbors(.down)?.count, 0, "block 5 should have zero down neighbor")
    XCTAssertEqual(game.block(1)?.neighbors(.down)?.count, 2, "block 1 should have two down neighbors")
    XCTAssertEqual(game.block(11)?.neighbors(.down)?.count, 1, "block 3 should have one down neighbor")
    XCTAssertEqual(game.block(2)?.neighbors(.down)?.count, 1, "block 2 should have one down neighbor")
    XCTAssertEqual(game.block(3)?.neighbors(.down)?.count, 1, "block 3 should have one down neighbor")
  }
  
  func testSetNeighbors1() {
    let game = GameModel(gridLayout1)
    
    //  [2, 2,  3, 0]
    //  [1, 1,  0, 4]
    //  [1, 1,  8, 4]
    //  [5, 7,  9, 11]
    //  [5, 10, 6, 6]
    
    XCTAssertEqual(game.block(2)?.neighbors(.left)?.count, 0, "block 2 should have zero left neighbor")
    XCTAssertEqual(game.block(1)?.neighbors(.left)?.count, 0, "block 1 should have zero left neighbor")
    XCTAssertEqual(game.block(6)?.neighbors(.left)?.count, 1, "block 6 should have one left neighbor")
    XCTAssertEqual(game.block(7)?.neighbors(.left)?.count, 1, "block 7 should have one left neighbor")
    XCTAssertEqual(game.block(4)?.neighbors(.left)?.count, 2, "block 4 should have two left neighbors")
    
    XCTAssertEqual(game.block(4)?.neighbors(.right)?.count, 0, "block 4 should have zero right neighbor")
    XCTAssertEqual(game.block(1)?.neighbors(.right)?.count, 2, "block 1 should have two right neighbors")
    XCTAssertEqual(game.block(3)?.neighbors(.right)?.count, 1, "block 3 should have one right neighbor")
    XCTAssertEqual(game.block(5)?.neighbors(.right)?.count, 2, "block 5 should have two right neighbor")
    XCTAssertEqual(game.block(2)?.neighbors(.right)?.count, 1, "block 2 should have one down neighbor")
    
    XCTAssertEqual(game.block(4)?.neighbors(.up)?.count, 1, "block 4 should have one top neighbor")
    XCTAssertEqual(game.block(2)?.neighbors(.up)?.count, 0, "block 2 should have zero top neighbor")
    XCTAssertEqual(game.block(1)?.neighbors(.up)?.count, 1, "block 1 should have one top neighbor")
    XCTAssertEqual(game.block(8)?.neighbors(.up)?.count, 1, "block 8 should have one top neighbor")
    XCTAssertEqual(game.block(5)?.neighbors(.up)?.count, 1, "block 5 should have one top neighbor")
    XCTAssertEqual(game.block(6)?.neighbors(.up)?.count, 2, "block 6 should have two top neighbors")
    
    XCTAssertEqual(game.block(5)?.neighbors(.down)?.count, 0, "block 5 should have zero down neighbor")
    XCTAssertEqual(game.block(1)?.neighbors(.down)?.count, 2, "block 1 should have two down neighbors")
    XCTAssertEqual(game.block(11)?.neighbors(.down)?.count, 1, "block 3 should have one down neighbor")
    XCTAssertEqual(game.block(2)?.neighbors(.down)?.count, 1, "block 2 should have one down neighbor")
  }
}
