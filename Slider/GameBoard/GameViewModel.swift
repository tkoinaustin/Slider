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
  
  func load(gameboard: [[Int]], size: CGSize) {
    game = GameModel(gameboard)
    self.size = size
    initBlocks(grid: gameboard)
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
        
        block.placeBlock(point: GridConstants.blockCenter(row: block.origin.row, col: block.origin.col, type: block.type))
        
        block.notifyDirection = { direction, index in
          assert(self.game != nil, "GameModel not set!")
          self.game.setGameboardsForMove(direction, index)
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
        block.placeBlock(point: GridConstants.blockCenter(row: block.origin.row, col: block.origin.col, type: block.type))
      }
    }

//  func rebuildGrid() {
//    gridLayout = GridConstants.blankLayout
//    for block in blocks {
//      gridLayout[block.origin.row][block.origin.col] = block.index
//      print("gridLayout[\(block.origin.row)][\(block.origin.col)] = \(block.index!)")
//      
//      switch block.type {
//      case .small:
//        continue
//      case .wide:
//        gridLayout[block.origin.row][block.origin.col+1] = block.index
//      case .tall:
//        gridLayout[block.origin.row+1][block.origin.col] = block.index
//      case .big:
//        gridLayout[block.origin.row][block.origin.col+1] = block.index
//        gridLayout[block.origin.row+1][block.origin.col] = block.index
//        gridLayout[block.origin.row+1][block.origin.col+1] = block.index
//      }
//    }
//  }
}
