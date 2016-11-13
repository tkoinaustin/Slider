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
  
  // swiftlint:disable comma
  let gridLayout = [[2,2,3,4],[1,1,0,4],[1,1,8,0],[5,7,9,11],[5,10,6,6]]
  // swiftlint:enable comma
  let game = GameboardViewModel()
  var block: BlockViewModel!
  
  func testInitBlocks() {
    let game = GameboardModel(gridLayout)
    XCTAssertTrue(game.blockCount > 0, "Blocks were not initialized")
  }

    override func setUp() {
      super.setUp()
      game.load(gameboard: gridLayout,
                size: CGSize.zero,
                start: UILabel(),
                finish: UILabel(),
                twoMove: UILabel()
      )

    }
  
  //  [2, 2,  3, 4]
  //  [1, 1,  0, 4]
  //  [1, 1,  8, 0]
  //  [5, 7,  9, 11]
  //  [5, 10, 6, 6]
}
