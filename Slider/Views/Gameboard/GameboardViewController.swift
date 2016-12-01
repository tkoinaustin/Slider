//
//  GameboardViewController.swift
//  Slider
//
//  Created by Mac Daddy on 10/4/16.
//  Copyright © 2016 TKO Solutions. All rights reserved.
//

import UIKit

class GameboardViewController: UIViewController {
  // swiftlint:disable comma
//  private var gridLayout = [[2,2,3,4],[1,1,0,4],[1,1,8,0],[5,7,9,11],[5,10,6,12]]
  private var gridLayout = [[2,1,1,3],[2,1,1,3],[4,6,6,5],[4,7,8,5],[9,0,0,10]]
  // swiftlint:enable comma
  var viewModel = GameboardViewModel()
  var loadNewPuzzle = true

  @IBOutlet private weak var gridView: UIView!
  @IBOutlet private weak var controlBar: ControlBarView! { didSet {
    viewModel.game.assignControlBar(controlBar.viewModel)
    viewModel.setControlBarClosure()
  }}
 
  @IBOutlet private weak var startingBoard: UILabel!
  @IBOutlet private weak var finishingBoard: UILabel!
  @IBOutlet private weak var twoMoveBoard: UILabel!

  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    guard loadNewPuzzle else { return }
    
    viewModel.loadGrid(gameboard: gridLayout,
                       size: gridView.frame.size,
                       start: startingBoard,
                       finish: finishingBoard,
                       twoMove: twoMoveBoard)
    
    viewModel.loadBlocks(gridView)
    viewModel.game.controlBar.parentViewController = self
    loadNewPuzzle = false
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    print("GameBoardViewController: didReceiveMemoryWarning()")
  }
  
}
