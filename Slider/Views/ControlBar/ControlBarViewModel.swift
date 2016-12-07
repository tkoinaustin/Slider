//
//  ControlBarViewModel.swift
//  Slider
//
//  Created by Tom Nelson on 11/10/16.
//  Copyright © 2016 TKO Solutions. All rights reserved.
//

import UIKit

class ControlBarViewModel: NSObject, NSCoding {
  var moveNumber: Int = 0 { didSet {
    print("move number: \(moveNumber)")
    if moveNumber != oldValue { updateControlBarUI() }
    if moveNumber != oldValue { print("updating move number to \(moveNumber)") }
  }}
  
  var moveDataCount: Int = 1
  var backEnabled: Bool { return moveDataCount > 1 }
  var forwardEnabled: Bool { return moveNumber < moveDataCount - 1 }
  
  var puzzleLabel: String = "Select Puzzle"
  var timer: Timer?
  var timerCount: TimeInterval = 0
  var parentViewController: UIViewController!
  
  var updateControlBarUI: (() -> ()) = {}
  var updateBlocksToMoveNumber: ((Int) -> ()) = {_ in }
  var trimMoveData: ((Int) -> ()) = { _ in }
  var puzzleToLoad: ((Gameboard?) -> ()) = { _ in }
  var load: (() -> ()) = { }
  var save: ((TimeInterval) -> ()) = { _ in }

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
  
  func loadIt() {
    load()
  }
  
  func saveIt() {
    save(timerCount)
  }
  
  func forward() {
    moveNumber += 1
    updateBlocksToMoveNumber(moveNumber)
  }
  
  func  backward () {
    guard moveNumber > 0 else { return }
    moveNumber -= 1
    updateBlocksToMoveNumber(moveNumber)
  }
  
  func newPuzzle(gameboard: Gameboard?) {
    guard let gameboard = gameboard else { return }

    puzzleLabel = "\(gameboard.name)"
    timerCount = 0
    moveNumber = 0
    updateControlBarUI()
    puzzleToLoad(gameboard)
  }
  
  func displayPuzzleList() {
    let puzzleListViewController: PuzzleListViewController = PuzzleListViewController()
    puzzleListViewController.loadNewPuzzle = newPuzzle
    
    let loginNavController = UINavigationController(rootViewController: puzzleListViewController)
    loginNavController.navigationItem.backBarButtonItem =
      UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(dismiss))
    
    parentViewController?.show(loginNavController, sender: self)
  }
  
  func dismiss() {
//    parentViewController.dismiss(animated: true, completion: nil)
  }

}
