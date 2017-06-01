//
//  ControlBarViewModel.swift
//  Slider
//
//  Created by Tom Nelson on 11/10/16.
//  Copyright © 2016 TKO Solutions. All rights reserved.
//

import UIKit

class ControlBarViewModel: NSObject, NSCoding {
  var puzzleSource: CGRect!
  var settingsButton: UIButton!
  var moveNumber: Int! { didSet {
    guard oldValue != nil else { return }
    if moveNumber != oldValue {
      updateControlBarUI()
    }
  }}
  
  private(set) var moveDataCount: Int = 1 { didSet {
    if moveDataCount != oldValue {
    }
  }}
  
  var backEnabled: Bool {
    guard moveNumber != nil else { return false }
    if gameOver { return false }

    return moveNumber > 0
  }
  var forwardEnabled: Bool {
    guard moveNumber != nil else { return false }
    if gameOver { return false }
    
    return moveNumber < moveDataCount - 1
  }
  var resetEnabled: Bool {
    guard moveNumber != nil else { return false }
    if gameOver { return false }

    return moveNumber > 0
  }
  
  var timerCount: TimeInterval = 0   
  var timerState: TimerState = .stop { didSet {
    if timerState != oldValue { updateTimerState(timerState) }
  }}
  
  var gameOver: Bool = false { didSet {
    if gameOver {
      timerState = .stop
      updateControlBarUI()
    }
  }}
  var puzzleLabel: String = ""
  var parentViewController: UIViewController!
  
  var updateControlBarUI: (() -> Void) = { }
  var updateTimerState: ((TimerState) -> Void) = { _ in }
  var updateBlocksToMoveNumber: ((Int) -> Void) = { _ in }
  
  var trimMoveData: ((Int) -> Void) = { _ in }
  var puzzleToLoad: ((PuzzleModel?) -> Void) = { _ in }
  var loadSettings: (() -> Void) = { }
  
  var load: (() -> Void) = { }
  var save: ((TimeInterval) -> Void) = { _ in }
  var saveHistory: (() -> Void) = { }
  var resetPuzzle: (() -> Void) = { }

  required convenience init?(coder aDecoder: NSCoder) {
    self.init()
    moveNumber = aDecoder.decodeInteger(forKey: "moveNumber")
    if let puzzleLabel1 = aDecoder.decodeObject(forKey: "puzzleLabel")
      as? String { puzzleLabel = puzzleLabel1 }
  }
  
  func encode(with aCoder: NSCoder) {
    aCoder.encode(moveNumber, forKey: "moveNumber")
    aCoder.encode(puzzleLabel, forKey: "puzzleLabel")
  }
  
  func addNotifications() {
    NotificationCenter.default.addObserver( self,
                                            selector: #selector(resignActive),
                                            name: .UIApplicationWillResignActive,
                                            object: nil)
  }
  
  func saveIt() {
    timerState = .stop
    save(timerCount)
  }
  
  func forward() {
    moveNumber = moveNumber ?? 0
    moveNumber! += 1
    updateBlocksToMoveNumber(moveNumber)
  }
  
  func  backward () {
    moveNumber = moveNumber ?? 0
    guard moveNumber > 0 else { return }
    moveNumber! -= 1
    updateBlocksToMoveNumber(moveNumber)
  }
  
  func increment(_ moveDataCount: Int) {
    if timerState != .start { timerState = .start }
    self.moveDataCount = moveDataCount
    moveNumber = moveNumber ?? 0
    moveNumber! += 1
  }
  
  func restoreGame(_ game: GameModel) {
    puzzleLabel = "\(game.name)"
    timerCount = game.gameTime
    moveNumber = game.moveData.count - 1
    moveDataCount = game.moveData.count
    timerState = .initialize
    updateControlBarUI()
  }
  
  func resetCurrentGame() {
    resetPuzzle()
    resetControlBar()
  }
  
  func resetControlBar() {
    moveDataCount = 1
    moveNumber = 0
    gameOver = false
    timerState = .reset
    updateControlBarUI()
  }
  
  func newPuzzle(puzzleModel: PuzzleModel?) {
    guard let puzzleModel = puzzleModel else { return }
    
    if puzzleModel.name != puzzleLabel && moveNumber ?? 0 > 0 {
      saveIt()
    }
    
    // load new puzzle
    gameOver = false
    puzzleLabel = "\(puzzleModel.name)"
    timerState = .reset
    moveDataCount = 1
    moveNumber = 0
    updateControlBarUI()
    puzzleToLoad(puzzleModel)
  }
  
  func displayPuzzleList() {
    timerState = .stop
    let puzzleListViewController: PuzzleListViewController = PuzzleListViewController()
    puzzleListViewController.preferredContentSize = CGSize(width: 400, height: 3000)
    puzzleListViewController.loadNewPuzzle = newPuzzle
    puzzleListViewController.saveHistory = saveHistory
    if let controller = parentViewController as? GameboardViewController {
      puzzleListViewController.currentIndex = controller.viewModel.game.index
    }
    
    let navController = UINavigationController(rootViewController: puzzleListViewController)
    navController.modalPresentationStyle = .popover
    navController.popoverPresentationController?.sourceRect = puzzleSource
    navController.popoverPresentationController?.sourceView = parentViewController?.view
    navController.popoverPresentationController?.permittedArrowDirections = .down
    
    parentViewController?.show(navController, sender: self)
  }
  
  func displaySettings() {
    timerState = .stop
    loadSettings()
  }
  
  @objc func resignActive() {
    saveIt()
  }
}
