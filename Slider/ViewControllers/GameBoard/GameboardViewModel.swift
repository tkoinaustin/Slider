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
  var FTUECompleted = false

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
  
  fileprivate func setGridClosures() {
    grid.updateGameboardUI = { 
      self.placeAllBlocks()
    }
    
    grid.gameModelMoveFinished = { [unowned self] move in
      guard let moveNumber = self.controlBar.moveNumber else { return }
      self.game.push(move, moveNumber: moveNumber)
      self.controlBar.increment(self.game.moveData.count)
    }
    
    grid.onWinning = { [unowned self] won in
      guard won else { return }
      
      self.game.won = true
      self.controlBar.gameOver = true
      self.saveHistory()
      for block in self.blocks { block.moveOffBoardInitialWin() }
      
      Delay.by(6) {
        self.winnerAlert(.winner)
      }
    }
  }
  
  func loadBlocks(_ gridView: UIView) {
    print("----- self.size = gridView.frame.size")
    self.size = gridView.frame.size

    for block in self.blocks {
      block.fadeOutAndRemove()
    }

    blocks.removeAll()

    for index in 0..<grid.blockCount {
      if let blockModel = grid.block(index) {
        let block = BlockViewModel(model: blockModel)
        
        block.canvas = size
        block.placeBlock(point: GridConstants.blockCenter(row: block.model.origin.row,
                                                          col: block.model.origin.col,
                                                          type: block.type))
        block.blockMoveStarted = { self.controlBar.timerState = .start }
        blocks.append(block)
      }
    }
    
    Delay.by(1) {
      for index in 1..<self.grid.blockCount {
        _ = CodedBlockView.getGameBlock(parent: gridView, game: self, index: index)
      }
    }
  }
  
  // swiftlint:disable function_body_length
  func setControlBarClosure() {
    // swiftlint:enable function_body_length
    controlBar.updateBlocksToMoveNumber = { [unowned self] index in
      assert(index < self.game.moveData.count, "index higher than moveData count")
      guard index < self.game.moveData.count else { return }
      
      let moveBoard = self.game.moveData[index].grid
      self.grid.setCurrentGrid(moveBoard)
      self.grid.updateBlockOriginsForBoard(moveBoard)
      self.grid.updateGameboardUI()
    }
    
    controlBar.trimMoveData = { [unowned self] index in
      self.game.trim(index)
    }
    
    controlBar.puzzleToLoad = { [unowned self] puzzleModel in
      guard let puzzleModel = puzzleModel else { return }
      self.game.prepareForNewGame(puzzleModel)
      self.loadPuzzle(puzzleModel.grid)
      for block in self.blocks { block.swipeEnabled = true }
    }
    
    controlBar.load = {
      _ = self.restoreGame()
    }
    
    controlBar.save = { [unowned self] counter in
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
      self.placeAllBlocks(1.5)
      self.game.trim(0)
    }
    
    controlBar.loadSettings = {
      self.gridView.parentViewController?.performSegue(withIdentifier: "settingsSegue",
                                                       sender: self.controlBar.settingsButton)
    }
  }
  
  func playAgain() {
    controlBar.resetControlBar()
    self.saveHistory()
    self.game.trim(0)
    self.game.datePlayed = Date()
    self.loadPuzzle(self.game.moveData.first?.grid)
    self.controlBar.enableControls()
  }
  
  func nextPuzzle() {
    var idx = game.index + 1
    if idx >= Puzzles().klotski.count { idx -= 1 }
    let puzzleModel = Puzzles().klotski[idx]
    controlBar.newPuzzle(puzzleModel: puzzleModel)
    self.controlBar.enableControls()
  }
  
  func block(_ index: Int) -> BlockViewModel {
    guard index < blocks.count && index > 0 else { return blocks[0] }
    
    return blocks[index]
  }
  
  func placeAllBlocks(_ time: Double = 0.2) {
    for block in blocks {
      block.placeBlock(point: GridConstants.blockCenter(row: block.model.origin.row,
                                                        col: block.model.origin.col,
                                                        type: block.type))
      block.updateBlockUI(time)
    }
  }

  func startGame() {
    guard FTUECompleted else { return }
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
  
  func saveGame() {
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
    
    replayViewModel.updateCounter = { [unowned self] index in
      self.controlBar.moveNumber = index - 1
    }
    
    replayViewModel.onCompletion = {
      self.winnerAlert(.replay)
    }
    
    replayViewModel.loadBlocks()
  }
    
  func displayPuzzleList() {
    self.controlBar.updateControlBarUI()
    self.controlBar.displayPuzzleList()
  }

  func winnerAlert(_ type: Alerts) {
    let notify = UIAlertController.init(title: type.title,
                                        message: type.message,
                                        preferredStyle: .alert)
    let okAction = UIAlertAction(title: "Next Puzzle",
                                 style: .cancel,
                                 handler: { [unowned self] _ in self.nextPuzzle() })
    notify.addAction(okAction)
    let replayAction = UIAlertAction(title: "Instant Replay",
                                     style: .default,
                                     handler: { [unowned self] _ in self.replayGame() })
    notify.addAction(replayAction)
    let puzzleListAction = UIAlertAction(title: "Puzzle List",
                                        style: .default,
                                        handler: { [unowned self] _ in self.displayPuzzleList() })
    notify.addAction(puzzleListAction)

    self.gridView.parentViewController?.present(notify,
                                                animated: true,
                                                completion: nil)
  }
}
