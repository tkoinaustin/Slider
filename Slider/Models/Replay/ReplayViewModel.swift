//
//  ReplayViewModel.swift
//  Slider
//
//  Created by Tom Nelson on 1/8/17.
//  Copyright © 2017 TKO Solutions. All rights reserved.
//

import UIKit
class ReplayViewModel {
  fileprivate var gridView: UIView!
  fileprivate var blockViews = [BlockViewModel]()
  fileprivate var blockModels = [BlockModel]()
  fileprivate var size: CGSize!
  fileprivate var grid: [[Int]]!
  var moveTimer: Timer!
  fileprivate var index = 1
  
  var game: GameModel! { didSet {
    grid = game.move(index: 0)?.grid
    }}
  
  var dismiss: (() -> ())  = { }
  
  var count: Int {
    return blockViews.count
  }
  
  func assignGridView(_ gridView: UIView) {
    self.gridView = gridView
  }
  
  func loadBlocks() {
    self.size = gridView.frame.size
    blockModels = GridModelInitialization().initBlocks(grid: grid)
    
    blockViews.removeAll()
    
    for index in 0..<blockModels.count {
      let block = BlockViewModel(model: blockModels[index])
      
      block.canvas = size
      block.placeBlock(point: GridConstants.blockCenter(row: block.model.origin.row,
                                                        col: block.model.origin.col,
                                                        type: block.type))
      blockViews.append(block)
    }
    
    for blockView in gridView.subviews { blockView.removeFromSuperview() }
    for index in 1..<blockModels.count {
      let _ = CodedBlockView.getReplayBlock(parent: gridView,
                                            blockModel: blockViews[index],
                                            index: index)
    }
    placeAllBlocks()
    moveTimer = Timer.scheduledTimer(timeInterval: 0.6,
                                     target: self,
                                     selector: #selector(moveBlocks),
                                     userInfo: nil,
                                     repeats: true)
  }
  
  func stopTimer() {
    if let _ = moveTimer {
      moveTimer.invalidate()
      moveTimer = nil
    }
  }
  
  fileprivate func block(_ index: Int) -> BlockViewModel {
    guard index < blockViews.count && index > 0 else { return blockViews[0] }
    
    return blockViews[index]
  }
  
  @objc fileprivate func moveBlocks() {
    if index < game.moveData.count { nextMove() }
    else { replayComplete() }
  }
  
  fileprivate func replayComplete() {
    stopTimer()
    var delay = 2.0
    
    if game.won {
      for block in self.blockViews { block.moveOffBoard() }
      delay = 4.0
    }
    Delay.by(delay) { self.dismiss() }
  }
  
    fileprivate func nextMove() {
      updateBlockOriginsForBoard(game.moveData[index].grid)
      moveAllBlocks(index)
      index += 1
    }
  
    fileprivate func updateBlockOriginsForBoard(_ grid: [[Int]]) {
      for row in (0..<Rows).reversed() {
        for col in (0..<Columns).reversed() {
          blockModels[grid[row][col]].origin = Coordinate(row: row, col: col)
        }
      }
    }
  
    fileprivate func moveAllBlocks(_ index: Int) {
      print(" Move all Blocks: \(index)")
      for block in blockViews {
        block.placeBlock(point: GridConstants.blockCenter(row: block.model.origin.row,
                                                          col: block.model.origin.col,
                                                          type: block.type))
        block.nextStep()
      }
    }
  
  fileprivate func placeAllBlocks() {
    for block in blockViews {
      block.placeBlock(point: GridConstants.blockCenter(row: block.model.origin.row,
                                                        col: block.model.origin.col,
                                                        type: block.type))
      block.fadeIn()
    }
  }
}
