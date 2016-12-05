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
  
  private var gridView: UIView!
  private var blocks = [BlockViewModel]()
  private var size: CGSize!
  private var grid: GridModel!
  private(set) var game = GameModel()
  
  var count: Int {
    return blocks.count
  }
  
  func assignGridView(_ gridView: UIView) {
    self.gridView = gridView
  }
  
  func loadPuzzle(_ puzzleGrid: [[Int]]?) {
    if let puzzleGrid = puzzleGrid { loadGrid(gameboard: puzzleGrid) }
    else { loadGrid(gameboard: puzzleGrid!) }
    
    loadBlocks(gridView)
  }
  
  func loadGrid(gameboard: [[Int]]) {
    if let grid = grid { grid.releaseBlocks() }
    
    grid = GridModel(gameboard)
    
    grid.gameboardViewModelUpdateUI = {
      self.placeAllBlocks()
    }
    
    grid.gameModelMoveFinished = { move in
      self.game.push(move)
    }
    
    guard game.moveData.isEmpty else { return } // restored games already have moveData
    let gameMoveData = GameMoveData(block: 0, direction: .up, grid: grid.currentGrid)
    game.setInitialGrid(gameMoveData)
  }

  func loadBlocks(_ gridView: UIView) {
    self.size = gridView.frame.size
    
    blocks.removeAll()

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
    
    for blockView in gridView.subviews { blockView.removeFromSuperview() }
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
      self.grid.gameboardViewModelUpdateUI()
    }
    
    game.controlBar.trimMoveData = { index in
      self.game.trim(index)
    }
    
    game.controlBar.puzzleToLoad = { gameboard in
      guard let gameboard = gameboard else { return }
      // here is where we need to save current data into history before loading new puzzle
      self.game.clearMoveData()
      self.game.name = gameboard.name
      self.loadPuzzle(gameboard.grid)
    }
    
    game.controlBar.load = {
      self.loadGame()
    }
    
    game.controlBar.save = { counter in
      self.game.gameTime = counter
      self.saveGame()
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
  
  func loadGame() {
    guard let restoredGame = Archiver.retrieve(model: .game) as? GameModel else { return }
    print("name: \(game.name)")
    game.copy(restoredGame)
    game.controlBar.puzzleLabel = "\(game.name)"
    game.controlBar.timerCount = game.gameTime
    game.controlBar.moveNumber = game.moveData.count - 1
    game.controlBar.updateControlBarUI()

    loadPuzzle(game.moveData.last?.grid)
  }
  
  func saveGame() {
    _ = Archiver.store(data: game, model: .game)
  }
}
