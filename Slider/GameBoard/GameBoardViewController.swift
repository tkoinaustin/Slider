//
//  GameBoardViewController.swift
//  Slider
//
//  Created by Mac Daddy on 10/4/16.
//  Copyright © 2016 TKO Solutions. All rights reserved.
//

import UIKit

class GameBoardViewController: UIViewController {
  
  var game = GameViewModel()

  @IBOutlet weak var gameView: UIView!
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    
    game.load(size: gameView.frame.size)
    
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
