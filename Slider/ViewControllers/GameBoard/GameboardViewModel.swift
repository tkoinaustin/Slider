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
  
  fileprivate var gridView: UIView!
  fileprivate var blocks = [BlockViewModel]()
  fileprivate var size: CGSize!
  fileprivate var grid: GridModel!
  fileprivate(set) var game = GameModel()
  fileprivate var parent: GameboardViewController!
  
  var count: Int {
    return blocks.count
  }
  
  func assignParent(_ parent: GameboardViewController) {
    self.parent = parent
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
    
    grid.onWinning = { won in
      guard won else { return }
      self.game.won = true
      self.game.controlBar.gameOver() 
//      self.saveHistory()
      
      // so something here to indicate a win
      // flashing blocks, pop up the game list controller, etc
      
      let notify = UIAlertController.init(title: "Winner, winner, chicken dinner!",
                                          message: "Good job",
                                          preferredStyle: .actionSheet)
      let okAction = UIAlertAction(title: "OK", style: .default)
      notify.addAction(okAction)
      self.parent.present(notify, animated: true, completion: nil)
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
      self.game.prepareForNewGame(gameboard)
      self.game.controlBar.saveEnabled = true
      self.loadPuzzle(gameboard.grid)
    }
    
    game.controlBar.load = {
      let _ = self.restoreGame()
    }
    
    game.controlBar.save = { counter in
      self.game.gameTime = counter
      self.saveGame()
    }
    
    game.controlBar.saveHistory = saveHistory
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
  
  func startGame() {    
    if !restoreGame() {
      game.controlBar.displayPuzzleList()
    }
  }
  
  func restoreGame() -> Bool {
    guard let restoredGame = Archiver.retrieve(model: .game) as? GameModel else { return false }
    print("name: \(game.name)")
    game.copy(restoredGame)
    game.controlBar.puzzleLabel = "\(game.name)"
    game.controlBar.timerCount = game.gameTime
    game.controlBar.moveNumber = game.moveData.count - 1
    game.controlBar.updateControlBarUI()

    loadPuzzle(game.moveData.last?.grid)
    
    return true
  }
  
  fileprivate func saveGame() {
    _ = Archiver.store(data: game, model: .game)
  }
  
  fileprivate func saveHistory() {
    print("saving history")
    let historyStore = HistoryStoreModel.shared
    guard game.moveData.count > 1 else { return }
    
    if historyStore.addGame(game, to: game.name) {
      _ = Archiver.store(data: historyStore.allGames, model: .historyStore)
    }
  }
}
