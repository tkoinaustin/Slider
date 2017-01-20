//
//  GameboardViewModel.swift
//  Slider
//
//  Created by Mac Daddy on 9/27/16.
//  Copyright © 2016 TKO Solutions. All rights reserved.
//

import UIKit

// swiftlint:disable file_length
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
  fileprivate(set) var controlBar = ControlBarViewModel()
  fileprivate let gradientLayer = CAGradientLayer()
  fileprivate var initialLoad = true

  var count: Int {
    return blocks.count
  }
  
  func assignGridView(_ gridView: UIView) {
    self.gridView = gridView
  }
  
  func assignControlBar(_ controlBar: ControlBarViewModel) {
    self.controlBar = controlBar
  }
  
  func loadPuzzle(_ puzzleGrid: [[Int]]?) {
    guard let puzzleGrid = puzzleGrid else { return }
    loadGrid(gameGrid: puzzleGrid)
    
    loadBlocks(gridView)
  }
  
  func loadGrid(gameGrid: [[Int]]) {
    grid = GridModel(gameGrid)
    setGridClosures()
    
    guard game.moveData.isEmpty else { return } // restored games already have moveData
    let gameMoveData = GameMoveData(block: 0, direction: .up, grid: grid.currentGrid)
    game.setInitialGrid(gameMoveData)
  }
  
  // swiftlint:disable function_body_length
  fileprivate func setGridClosures() {
    // swiftlint:enable function_body_length
    grid.updateGameboardUI = {
      self.placeAllBlocks()
    }
    
    grid.gameModelMoveFinished = { move in
      guard let moveNumber = self.controlBar.moveNumber else { return }
      self.game.push(move, moveNumber: moveNumber)
      self.controlBar.increment(self.game.moveData.count)
    }
    
    grid.onWinning = { won in
      guard won else { return }
      self.game.won = true
      self.controlBar.gameOver = true
      self.saveHistory()
      for block in self.blocks { block.moveOffBoard() }
      
      Delay.by(4) {
        self.winnerAlert(.winner)
      }
    }
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
      let _ = CodedBlockView.getGameBlock(parent: gridView, game: self, index: index)
    }
  }
  
  // swiftlint:disable function_body_length
  func setControlBarClosure() {
    // swiftlint:enable function_body_length
    controlBar.updateBlocksToMoveNumber = { index in
      assert(index < self.game.moveData.count, "index higher than moveData count")
      guard index < self.game.moveData.count else { return }
      
      let moveBoard = self.game.moveData[index].grid
      self.grid.setCurrentGrid(moveBoard)
      self.grid.updateBlockOriginsForBoard(moveBoard)
      self.grid.updateGameboardUI()
    }
    
    controlBar.trimMoveData = { index in
      self.game.trim(index)
    }
    
    controlBar.puzzleToLoad = { puzzleModel in
      guard let puzzleModel = puzzleModel else { return }
      self.game.prepareForNewGame(puzzleModel)
      self.loadPuzzle(puzzleModel.grid)
      for block in self.blocks { block.swipeEnabled = true }
    }
    
    controlBar.load = {
      let _ = self.restoreGame()
    }
    
    controlBar.save = { counter in
      guard self.game.won == false else { return }
      self.game.gameTime = counter
      self.saveGame()
    }
    
    controlBar.saveHistory = saveHistory
    
    controlBar.resetPuzzle = {
      print("resetPuzzle")
      guard !self.game.moveData.isEmpty else { return }

      self.saveHistory()
      self.game.datePlayed = Date()
      self.grid.setCurrentGrid((self.game.moveData.first?.grid)!)
      self.grid.updateBlockOriginsForBoard(self.grid.currentGrid)
      self.placeAllBlocks()
      self.game.trim(0)
    }
    
    controlBar.loadSettings = {
      self.gridView.parentViewController?.performSegue(withIdentifier: "settingsSegue", sender: self)
    }
  }
  
  func playAgain() {
    controlBar.resetControlBar()
    self.saveHistory()
    self.game.trim(0)
    self.game.datePlayed = Date()
    self.loadPuzzle(self.game.moveData.first?.grid)
  }
  
  func nextPuzzle() {
    var idx = game.index + 1
    if idx >= Puzzles().klotski.count { idx -= 1 }
    let puzzleModel = Puzzles().klotski[idx]
    controlBar.newPuzzle(puzzleModel: puzzleModel)
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
      block.updateBlockUI(0.2)
    }
  }
  
  func startGame() {
    guard initialLoad else { return }
    initialLoad = false

    if !restoreGame() {
      let puzzleModel = Puzzles().klotski[0]
      controlBar.newPuzzle(puzzleModel: puzzleModel)
    }
  }
  
  func restoreGame() -> Bool {
    guard let restoredGame = Archiver.retrieve(model: .game) as? GameModel else { return false }
    
    guard !restoredGame.won else { return false }
    
    game.copy(restoredGame)
    controlBar.restoreGame(game)

    guard !game.moveData.isEmpty else { return false }
    
    loadPuzzle(game.moveData.last?.grid)
    print(" restoreGame: \(game.name)")
    
    return true
  }
  
  fileprivate func saveGame() {
    _ = Archiver.store(data: game, model: .game)
    print("setting game to \(game.name)")
  }
  
  fileprivate func saveHistory() {
    _ = Archiver.saveHistory(game)
  }
  
  func replayGame() {
    let replayViewModel = ReplayViewModel()
    controlBar.moveNumber = 0
    replayViewModel.game = self.game
    replayViewModel.assignGridView(gridView)
    replayViewModel.updateCounter = { index in
      self.controlBar.moveNumber = index - 1
    }
    replayViewModel.onCompletion = {
      self.winnerAlert(.replay)
    }
    replayViewModel.loadBlocks()
  }
  
  func winnerAlert(_ type: Alerts) {
    let notify = UIAlertController.init(title: type.title,
                                        message: type.message,
                                        preferredStyle: .alert)
    let okAction = UIAlertAction(title: "Next Puzzle",
                                 style: .cancel,
                                 handler: { _ in self.nextPuzzle() })
    notify.addAction(okAction)
    let replayAction = UIAlertAction(title: "Instant Replay",
                                     style: .default,
                                     handler: { _ in self.replayGame() })
    notify.addAction(replayAction)
    let playAgainAction = UIAlertAction(title: "Play Again",
                                        style: .default,
                                        handler: { _ in self.playAgain() })
    notify.addAction(playAgainAction)
    self.gridView.parentViewController?.present(notify,
                                                animated: true,
                                                completion: nil)
  }
}
