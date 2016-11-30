//
//  ArchiveTests.swift
//  Slider
//
//  Created by Tom Nelson on 11/19/16.
//  Copyright © 2016 TKO Solutions. All rights reserved.
//

import XCTest
@testable import Slider

class ArchiveTests: XCTestCase {
  var moveDatum: GameMoveData!
  var moveData: [GameMoveData]!
  var gameModel: GameModel!
  
  override func setUp() {
    super.setUp()
    // swiftlint:disable comma
    moveDatum = GameMoveData(block: 5,
                             direction: .down,
                             grid: [[2,2,3,4],[1,1,0,4],[1,1,8,0],[5,7,9,11],[5,10,6,6]])
    
    moveData = [GameMoveData(block: 5,
                             direction: .down,
                             grid: [[2,2,3,4],[1,1,0,4],[1,1,8,0],[5,7,9,11],[5,10,6,6]]),
                GameMoveData(block: 5,
                             direction: .down,
                             grid: [[2,2,3,4],[1,1,0,4],[1,1,8,0],[5,7,9,11],[5,10,6,6]]),
                GameMoveData(block: 5,
                             direction: .down,
                             grid: [[2,2,3,4],[1,1,0,4],[1,1,8,0],[5,7,9,11],[5,10,6,6]])]
    
    gameModel = GameModel(completed: false, datePlayed: Date(), gameTime: 10, moveData: moveData)
    // swiftlint:enable comma
  }
  
  func testGameMoveDataArchiveAndUnarchive() {
    _ = Archiver.store(data: moveDatum, model: .move)
    
    guard let move = Archiver.retrieve(model: .move) as? GameMoveData else { return }
    print (move)
    XCTAssertTrue(move.block == 5)
    XCTAssertTrue(move.direction == .down)
    XCTAssertTrue(move.grid[4] == [5, 10, 6, 6])
  }
  
  func testGameModelArchiveAndUnarchive() {
    _ = Archiver.store(data: gameModel, model: .game)
    
    guard let game = Archiver.retrieve(model: .game) as? GameModel else { return }
    print (game)
    XCTAssertTrue(game.completed == false)
    XCTAssertTrue(game.gameTime == 10)
    XCTAssertTrue(game.moveData[1].grid[4] == [5, 10, 6, 6])
  }
  
 }
