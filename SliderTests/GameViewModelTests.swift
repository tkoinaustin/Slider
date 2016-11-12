//
//  GameViewModelTests.swift
//  Game
//
//  Created by Tom Nelson on 9/27/16.
//  Copyright © 2016 Tom Nelson. All rights reserved.
//

import XCTest
@testable import Slider

class GameViewModelTests: XCTestCase {
 
  // swiftlint:disable comma
  let gridLayout = [[2,2,3,4],[1,1,0,4],[1,1,8,0],[5,7,9,11],[5,10,6,6]]
  let gridLayout1 = [[2,2,3,0],[1,1,0,4],[1,1,8,4],[5,7,9,11],[5,10,6,6]]
  // swiftlint:enable comma

  func testInit() {
    let game = GameViewModel()
    XCTAssertNotNil(game, "Grid object not created")
  }
  
  func testInitBlocks() {
    let game = GameViewModel()
    game.load(gameboard: gridLayout,
              size: CGSize.zero,
              start: UILabel(),
              finish: UILabel(),
              twoMove: UILabel()
              )
// swiftlint:disable empty_count
    XCTAssertTrue(game.count > 0, "Blocks were not initialized")
    // swiftlint:enable empty_count
  }
}
