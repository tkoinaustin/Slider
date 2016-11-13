//
//  GameModelLogicTests.swift
//  Slider
//
//  Created by Mac Daddy on 10/15/16.
//  Copyright © 2016 TKO Solutions. All rights reserved.
//

import XCTest
@testable import Slider

class GameModelLogicTests: XCTestCase {
    
  // swiftlint:disable comma
  let gameLayout = [[2,2,3,4],[1,1,0,4],[1,1,8,0],[5,7,9,11],[5,10,6,6]]
  var game: GameboardModel!
  var block: BlockModel!
  let logic = GameboardModelLogic()
  
  override func setUp() {
    super.setUp()
    game = GameboardModel(gameLayout)
  }
  
  //  [2, 2,  3, 4]
  //  [1, 1,  0, 4]
  //  [1, 1,  8, 0]
  //  [5, 7,  9, 11]
  //  [5, 10, 6, 6]
  
  func testNewGridForUpMove4() {
    let newGame =  logic.newGridForMove(gameLayout, 1, .up)
    XCTAssertNil(newGame)
  }
  
  func testNewGridForUpMove3() {
    let newGame =  logic.newGridForMove(gameLayout, 6, .up)
    XCTAssertTrue((newGame?[0])! == [2,2,3,4], "grids don't match")
    XCTAssertTrue((newGame?[1])! == [1,1,8,4], "grids don't match")
    XCTAssertTrue((newGame?[2])! == [1,1,9,11], "grids don't match")
    XCTAssertTrue((newGame?[3])! == [5,7,6,6], "grids don't match")
    XCTAssertTrue((newGame?[4])! == [5,10,0,0], "grids don't match")
  }
  
  func testNewGridForUpMove2() {
    let newGame =  logic.newGridForMove(gameLayout, 11, .up)
    XCTAssertTrue((newGame?[0])! == [2,2,3,4], "grids don't match")
    XCTAssertTrue((newGame?[1])! == [1,1,0,4], "grids don't match")
    XCTAssertTrue((newGame?[2])! == [1,1,8,11], "grids don't match")
    XCTAssertTrue((newGame?[3])! == [5,7,9,0], "grids don't match")
  }
  
  func testNewGridForUpMove1() {
    let newGame =  logic.newGridForMove(gameLayout, 8, .up)
    XCTAssertTrue((newGame?[0])! == [2,2,3,4], "grids don't match")
    XCTAssertTrue((newGame?[1])! == [1,1,8,4], "grids don't match")
    XCTAssertTrue((newGame?[2])! == [1,1,0,0], "grids don't match")

  }
  
  func testNewGridForUpMove() {
    let newGame =  logic.newGridForMove(gameLayout, 9, .up)
    XCTAssertTrue((newGame?[0])! == [2,2,3,4], "grids don't match")
    XCTAssertTrue((newGame?[1])! == [1,1,8,4], "grids don't match")
    XCTAssertTrue((newGame?[2])! == [1,1,9,0], "grids don't match")
    XCTAssertTrue((newGame?[3])! == [5,7,0,11], "grids don't match")
  }

  let gameLayout1 = [[2,2,3,4],[1,1,0,4],[1,1,8,11],[7,5,9,0],[10,5,0,6]]
  //  [2, 2, 3, 4]
  //  [1, 1, 0, 4]
  //  [1, 1, 8,11]
  //  [7, 5, 9, 0]
  //  [10,5, 0, 6]
  
  func testNewGridForRightMove2() {
    let newGame =  logic.newGridForMove(gameLayout1, 7, .right)
    XCTAssertTrue((newGame?[0])! == [2,2,3,4], "grids don't match")
    XCTAssertTrue((newGame?[1])! == [1,1,0,4], "grids don't match")
    XCTAssertTrue((newGame?[2])! == [1,1,8,11], "grids don't match")
    XCTAssertTrue((newGame?[3])! == [0,7,5,9], "grids don't match")
    XCTAssertTrue((newGame?[4])! == [10,0,5,6], "grids don't match")
  }
  
  func testNewGridForRightMove1() {
    let newGame =  logic.newGridForMove(gameLayout1, 5, .right)
    XCTAssertTrue((newGame?[0])! == [2,2,3,4], "grids don't match")
    XCTAssertTrue((newGame?[1])! == [1,1,0,4], "grids don't match")
    XCTAssertTrue((newGame?[2])! == [1,1,8,11], "grids don't match")
    XCTAssertTrue((newGame?[3])! == [7,0,5,9], "grids don't match")
    XCTAssertTrue((newGame?[4])! == [10,0,5,6], "grids don't match")
  }
  
  func testNewGridForRightMove() {
    let newGame =  logic.newGridForMove(gameLayout1, 9, .right)
    XCTAssertTrue((newGame?[0])! == [2,2,3,4], "grids don't match")
    XCTAssertTrue((newGame?[1])! == [1,1,0,4], "grids don't match")
    XCTAssertTrue((newGame?[2])! == [1,1,8,11], "grids don't match")
    XCTAssertTrue((newGame?[3])! == [7,5,0,9], "grids don't match")
    XCTAssertTrue((newGame?[4])! == [10,5,0,6], "grids don't match")
  }
}
