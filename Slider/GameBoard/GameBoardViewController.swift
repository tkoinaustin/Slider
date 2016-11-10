//
//  GameBoardViewController.swift
//  Slider
//
//  Created by Mac Daddy on 10/4/16.
//  Copyright © 2016 TKO Solutions. All rights reserved.
//

import UIKit

class GameBoardViewController: UIViewController {
  // swiftlint:disable comma
  private var gridLayout = [[2,2,3,4],[1,1,0,4],[1,1,8,0],[5,7,9,11],[5,10,6,12]]
  // swiftlint:enable comma
  var game = GameViewModel()

  @IBOutlet private weak var gameView: UIView!
  @IBOutlet private weak var startingBoard: UILabel!
  @IBOutlet private weak var finishingBoard: UILabel!
  @IBOutlet private weak var twoMoveBoard: UILabel!
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    
    game.load(gameboard: gridLayout,
              size: gameView.frame.size,
              start: startingBoard,
              finish: finishingBoard,
              twoMove: twoMoveBoard)
    
    let _ = CodedBlockView.get(parent: gameView, game: game, index: 1)
    let _ = CodedBlockView.get(parent: gameView, game: game, index: 2)
    let _ = CodedBlockView.get(parent: gameView, game: game, index: 3)
    let _ = CodedBlockView.get(parent: gameView, game: game, index: 4)
    let _ = CodedBlockView.get(parent: gameView, game: game, index: 5)
    let _ = CodedBlockView.get(parent: gameView, game: game, index: 6)
    let _ = CodedBlockView.get(parent: gameView, game: game, index: 7)
    let _ = CodedBlockView.get(parent: gameView, game: game, index: 8)
    let _ = CodedBlockView.get(parent: gameView, game: game, index: 9)
    let _ = CodedBlockView.get(parent: gameView, game: game, index: 10)
    let _ = CodedBlockView.get(parent: gameView, game: game, index: 11)
    let _ = CodedBlockView.get(parent: gameView, game: game, index: 12)
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    print("GameBoardViewController: didReceiveMemoryWarning()")
  }
  
}
