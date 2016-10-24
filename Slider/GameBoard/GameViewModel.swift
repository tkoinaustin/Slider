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

  var count: Int {
    return blocks.count
  }
  
  func load(gameboard: [[Int]], size: CGSize, start: UILabel, finish: UILabel, twoMove: UILabel) {
    game = GameModel(gameboard)
    self.size = size
    initBlocks(grid: gameboard)
    game.start = start
    game.finish = finish
    game.twoMove = twoMove
    game.gameViewModelUpdateUI = {
      self.placeAllBlocks()
    }
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
        blocks.append(block)
      }
    }
  }
  
    func placeAllBlocks() {
      print("----- placeAllBlocks -----")
      for block in blocks {
        block.placeBlock(point: GridConstants.blockCenter(row: block.model.origin.row, col: block.model.origin.col, type: block.type))
        block.updateUI()
      }
    }
}
