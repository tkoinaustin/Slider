//
//  ReplayBoardViewController.swift
//  Slider
//
//  Created by Tom Nelson on 12/13/16.
//  Copyright © 2016 TKO Solutions. All rights reserved.
//

import UIKit

class ReplayBoardViewController: UIViewController {
  
  var viewModel = ReplayBoardViewModel()
  var gameModel: GameModel! { didSet {
    viewModel.assignGameModel(gameModel)
  }}
  
  var replayText: String = ""
  var index: Int!
  
  @IBOutlet private weak var gradientView: UIView!
  @IBOutlet private weak var replayLabel: UILabel! { didSet {
    replayLabel.text = replayText
  }}
  
  @IBOutlet private weak var replayGrid: UIView!  { didSet {
    viewModel.assignGridView(replayGrid)
  }}

  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    viewModel.loadBlocks()
    viewModel.fillGradient(gradientView)
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.title = "Game \(index! + 1)"
    
    navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done,
                                                       target: self,
                                                       action: #selector(dismissController))
  }

func dismissController() {
  dismiss(animated: true, completion: nil)
}

}
