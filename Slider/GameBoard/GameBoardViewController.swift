//
//  GameBoardViewController.swift
//  Slider
//
//  Created by Mac Daddy on 10/4/16.
//  Copyright © 2016 TKO Solutions. All rights reserved.
//

import UIKit

class GameBoardViewController: UIViewController {
  
  private var gridLayout = [[2,2,3,4],[1,1,0,4],[1,1,8,0],[5,7,9,11],[5,10,6,6]]
  var game = GameViewModel()

  @IBOutlet weak var gameView: UIView!
  @IBOutlet weak var startingBoard: UILabel!
  @IBOutlet weak var finishingBoard: UILabel!
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    
    game.load(gameboard: gridLayout,
              size: gameView.frame.size,
              start: startingBoard,
              finish: finishingBoard)
    
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
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    print("GameBoardViewController: didReceiveMemoryWarning()")
  }
  
}
