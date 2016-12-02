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
  
  func loadGrid(gameboard: [[Int]],
                start: UILabel,
                finish: UILabel,
                twoMove: UILabel) {
    grid = GridModel(gameboard)
    
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

  func loadBlocks(_ gridView: UIView) {
    self.size = gridView.frame.size

    for index in 0..<grid.blockCount {
      if let blockModel = grid.block(index) {
        let block = BlockViewModel(model: blockModel)
        
        block.canvas = size
        block.placeBlock(point: GridConstants.blockCenter(row: block.model.origin.row,
                                                          col: block.model.origin.col,
                                                          type: block.type))
        blocks.append(block)
      }
    }
    
    for index in 1..<grid.blockCount {
      let _ = CodedBlockView.get(parent: gridView, game: self, index: index)
    }
  }
  
  func setControlBarClosure() {
    game.controlBar.updateBlocksToMoveNumber = { index in
      assert(index < self.game.moveData.count, "index higher than moveData count")
      guard index < self.game.moveData.count else { return }
      
      let moveBoard = self.game.moveData[index].grid
      self.grid.setCurrentGrid(moveBoard)
      self.grid.updateBlockOriginsForBoard(moveBoard)
      self.grid.gridViewModelUpdateUI()
    }
    
    game.controlBar.trimMoveData = { index in
      self.game.trim(index)
    }
  }
  
  func block(_ index: Int) -> BlockViewModel {
    guard index < blocks.count && index > 0 else { return blocks[0] }
    
    return blocks[index]
  }
  
  func placeAllBlocks() {
    for block in blocks {
      block.placeBlock(point: GridConstants.blockCenter(row: block.model.origin.row,
                                                        col: block.model.origin.col,
                                                        type: block.type))
      block.updateUI()
    }
  }
}
