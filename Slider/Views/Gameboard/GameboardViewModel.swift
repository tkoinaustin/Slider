//
//  GameboardViewModel.swift
//  Slider
//
//  Created by Mac Daddy on 9/27/16.
//  Copyright © 2016 TKO Solutions. All rights reserved.
//

import UIKit

// swiftlint:disable variable_name
let Rows = 5
let Columns = 4
// swiftlint:enable variable_name

class GameboardViewModel {
  
  private var blocks = [BlockViewModel]()
  private var size: CGSize!
  private var grid: GridModel!
  private(set) var game = GameModel()
  
  var count: Int {
    return blocks.count
  }
  
  func load(gameboard: [[Int]], size: CGSize, start: UILabel, finish: UILabel, twoMove: UILabel) {
    print("GameboardViewModel load")
    grid = GridModel(gameboard)
    self.size = size
    initBlocks()
    
    grid.start = start
    grid.finish = finish
    grid.twoMove = twoMove
    
    grid.gridViewModelUpdateUI = {
      self.placeAllBlocks()
    }
    grid.gameModelMoveFinished = { move in
      self.game.push(move)
    }
    
    let gameMoveData = GameMoveData(block: 0, direction: nil, grid: grid.currentGrid)
    game.setInitialGrid(gameMoveData)
  }
  
  func setControlBarClosure() {
    game.controlBar.updateBlocksToMoveNumber = { index in
      let moveBoard = self.game.moveData[index].grid
      self.grid.updateBlockOriginsForBoard(moveBoard)
      self.grid.gridViewModelUpdateUI()
    }
  }
  
  func block(_ index: Int) -> BlockViewModel {
    guard index < blocks.count && index > 0 else { return blocks[0] }
    
    return blocks[index]
  }
  
  func initBlocks() {
    // most of this has been pushed into GameModel
    for index in 0..<grid.blockCount {
      if let blockModel = grid.block(index) {
        let block = BlockViewModel(model: blockModel)
        
        if let size = size { block.canvas = size }
        else { block.canvas = CGSize(width: 320, height: 400) }
        
        block.placeBlock(point: GridConstants.blockCenter(row: block.model.origin.row,
                                                          col: block.model.origin.col,
                                                          type: block.type))
        blocks.append(block)
      }
    }
  }
  
  func placeAllBlocks() {
    print("----- placeAllBlocks -----")
    for block in blocks {
      block.placeBlock(point: GridConstants.blockCenter(row: block.model.origin.row,
                                                        col: block.model.origin.col,
                                                        type: block.type))
      block.updateUI()
    }
  }
}
