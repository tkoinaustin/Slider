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
    
  }
  
  func testGameModelArchiveAndUnarchive() {
    _ = Archiver.store(data: gameModel, model: .game)
    
    guard let game = Archiver.retrieve(model: .game) as? GameModel else { return }
    print (game)
    XCTAssertTrue(game.gameTime == 10)
    XCTAssertTrue(game.moveData[1].grid[4] == [5, 10, 6, 6])
  }
  
 }
