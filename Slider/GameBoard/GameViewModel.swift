//
//  GameViewModel.swift
//  Slider
//
//  Created by Mac Daddy on 9/27/16.
//  Copyright © 2016 TKO Solutions. All rights reserved.
//

import UIKit

let Rows = 5
let Columns = 4

class GameViewModel {
  
  private var blocks = [BlockViewModel]()
  private var size: CGSize!
  private var game: GameModel!
  private var start: UILabel!
  private var finish: UILabel!

  var count: Int {
    return blocks.count
  }
  
  func load(gameboard: [[Int]], size: CGSize, start: UILabel, finish: UILabel) {
    game = GameModel(gameboard)
    self.size = size
    initBlocks(grid: gameboard)
    self.start = start
    self.finish = finish
  }
  
  func block(_ index: Int) -> BlockViewModel {
    guard index < blocks.count && index > 0 else { return blocks[0] }
    
    return blocks[index]
  }
  
  func initBlocks(grid: [[Int]]) {
    // most of this has been pushed into GameModel
    for index in 0..<game.blockCount {
      if let blockModel = game.block(index) {
        let block = BlockViewModel(model: blockModel)
        
        if let size = size { block.canvas = size }
        else { block.canvas = CGSize(width: 320, height: 400) }
        
        block.placeBlock(point: GridConstants.blockCenter(row: block.model.origin.row, col: block.model.origin.col, type: block.type))
        
        block.notifyDirection = { direction, index in
          assert(self.game != nil, "GameModel not set!")
          self.game.setGameboardsForMove(direction, index)
          self.game.showGameboardsForMove(self.start, self.finish)
        }

        block.moveFinished = { _ in
          // these will be routed to GameModel.logic and performed there
          self.placeAllBlocks()
          self.game.updateGridForSingleMove()
//          self.setNeighbors(grid: self.gridLayout)
        }
        
        blocks.append(block)
      }
    }
  }
  
    func placeAllBlocks() {
      for block in blocks {
        block.placeBlock(point: GridConstants.blockCenter(row: block.model.origin.row, col: block.model.origin.col, type: block.type))
      }
    }
}
