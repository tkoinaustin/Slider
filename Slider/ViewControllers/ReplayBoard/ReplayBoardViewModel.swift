//
//  ReplayBoardViewModel.swift
//  Slider
//
//  Created by Tom Nelson on 12/28/16.
//  Copyright © 2016 TKO Solutions. All rights reserved.
//

import UIKit

class ReplayBoardViewModel {
  fileprivate var gridView: UIView!
  fileprivate var blockViews = [BlockViewModel]()
  fileprivate var blockModels = [BlockModel]()
  fileprivate var size: CGSize!
  fileprivate var parent: ReplayBoardViewController!
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
  
  func assignParent(_ parent: ReplayBoardViewController) {
    self.parent = parent
  }
  
  func assignGridView(_ gridView: UIView) {
    self.gridView = gridView
  }
  
  func fillGradient(_ gradientView: UIView) {
    let gradientLayer  = CAGradientLayer()
    gradientLayer.frame.size = gradientView.frame.size
    let color = UIColor.white
    gradientLayer.colors = [
      color.withAlphaComponent(0.000).cgColor,
      color.withAlphaComponent(0.012).cgColor,
      color.withAlphaComponent(0.059).cgColor,
      color.withAlphaComponent(0.155).cgColor,
      color.withAlphaComponent(0.308).cgColor,
      color.withAlphaComponent(0.500).cgColor,
      color.withAlphaComponent(0.692).cgColor,
      color.withAlphaComponent(0.844).cgColor,
      color.withAlphaComponent(0.941).cgColor,
      color.withAlphaComponent(0.989).cgColor,
      color.withAlphaComponent(1.000).cgColor
    ]
    gradientView.layer.addSublayer(gradientLayer)
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
      let _ = CodedBlockView.getReplayBlock(parent: gridView, blockModel: blockViews[index], index: index)
    }
    placeAllBlocks()
    moveTimer = Timer.scheduledTimer(timeInterval: 0.6, target: self, selector: #selector(moveBlocks), userInfo: nil, repeats: true)
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

  @objc fileprivate func moveBlocks() -> Bool {
    guard index < game.moveData.count else {
      stopTimer()
      if game.won { blockViews[1].moveOffBoard() }
      Delay.by(2) {
        self.dismiss()
      }
      return false
    }
    
    updateBlockOriginsForBoard(game.moveData[index].grid)
    moveAllBlocks(index)
    index += 1
    return true
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
