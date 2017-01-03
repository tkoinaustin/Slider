//
//  ControlBarViewModel.swift
//  Slider
//
//  Created by Tom Nelson on 11/10/16.
//  Copyright © 2016 TKO Solutions. All rights reserved.
//

import UIKit

class ControlBarViewModel: NSObject, NSCoding {
  var moveNumber: Int! { didSet {
    guard let _ = oldValue else { return }
    if moveNumber != oldValue { updateControlBarUI() }
  }}
  
  var moveDataCount: Int = 1 { didSet {
      print("move data count is \(moveDataCount)")
//    if moveDataCount != oldValue { updateControlBarUI() }
  }}
  var backEnabled: Bool {
    guard let _ = moveNumber else { return false }
    if gameOver { return false }

    return moveNumber > 0
  }
  var forwardEnabled: Bool {
    guard let _ = moveNumber else { return false }
    if gameOver { return false }
    
    print("moveNumber: \(moveNumber), moveDataCount: \(moveDataCount)")
    return moveNumber < moveDataCount - 1
  }
  var resetEnabled: Bool {
    guard let _ = moveNumber else { return false }
    if gameOver { return false }

    return moveNumber > 0
  }
  
  var timerCount: TimeInterval = 0
  var timerState: TimerState = .start { didSet {
      updateTimerState(timerState)
  }}
  
  var gameOver: Bool = false { didSet {
    if gameOver {
      timerState = .stop
      updateControlBarUI()
    }
  }}
  var puzzleLabel: String = "Select Puzzle"
  var parentViewController: UIViewController!
  
  var updateControlBarUI: (() -> ()) = {}
  var updateTimerState: ((TimerState) -> ()) = {_ in}
  var updateBlocksToMoveNumber: ((Int) -> ()) = {_ in }
  
  var trimMoveData: ((Int) -> ()) = { _ in }
  var puzzleToLoad: ((Gameboard?) -> ()) = { _ in }
  
  var load: (() -> ()) = { }
  var save: ((TimeInterval) -> ()) = { _ in }
  var saveHistory: (() -> ()) = { }
  var resetPuzzle: (() -> ()) = { }

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
                                            selector: #selector(becomeActive),
                                            name: .UIApplicationDidBecomeActive ,
                                            object: nil)
    
    NotificationCenter.default.addObserver( self,
                                            selector: #selector(resignActive),
                                            name: .UIApplicationWillResignActive,
                                            object: nil)
  }

  func loadIt() {
    timerState = .start
    load()
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
  
  func restoreGame(_ game: GameModel) {
    puzzleLabel = "\(game.name)"
    timerCount = game.gameTime
    moveNumber = game.moveData.count - 1
    updateControlBarUI()
  }
  
  func resetCurrentGame() {
    resetPuzzle()
    moveNumber = 0
    timerState = .reset
    updateControlBarUI()
  }
  
  func newPuzzle(gameboard: Gameboard?) {
    guard let gameboard = gameboard else { timerState = .start; return }
    
    // save existing puzzle if there are any moves and the puzzle is 
    // different than the current puzzle
    if gameboard.name != puzzleLabel && moveNumber ?? 0 > 0 {
      //save history, not puzzle!!
      saveIt()
    }
    
    // load new puzzle
    puzzleLabel = "\(gameboard.name)"
    timerState = .reset
    moveDataCount = 1
    moveNumber = 0
    updateControlBarUI()
    puzzleToLoad(gameboard)
  }
  
  func displayPuzzleList() {
    timerState = .stop
    let puzzleListViewController: PuzzleListViewController = PuzzleListViewController()
    puzzleListViewController.preferredContentSize = CGSize(width: 400, height: 3000)
    puzzleListViewController.loadNewPuzzle = newPuzzle
    puzzleListViewController.saveHistory = saveHistory
    
    let navController = UINavigationController(rootViewController: puzzleListViewController)
    navController.modalPresentationStyle = .popover
    navController.popoverPresentationController?.sourceView = parentViewController?.view
    navController.popoverPresentationController?.delegate = self
    
    navController.navigationItem.backBarButtonItem =
      UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(dismiss))
    
    parentViewController?.show(navController, sender: self)
  }
  
  func dismiss() {
//    parentViewController.dismiss(animated: true, completion: nil)
  }
  
  @objc func becomeActive() {
    print("----- become active  -----")
    timerState = .start
  }
  
  @objc func resignActive() {
    print("----- resign active  -----")
    saveIt()
  }
}

extension ControlBarViewModel: UIPopoverPresentationControllerDelegate {
  // swiftlint:disable line_length
  func popoverPresentationControllerDidDismissPopover(_ popoverPresentationController: UIPopoverPresentationController) {
    timerState = .start
  }
  // swiftlint:enable line_length
}
