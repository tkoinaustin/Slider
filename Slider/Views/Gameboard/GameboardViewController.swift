//
//  GameboardViewController.swift
//  Slider
//
//  Created by Mac Daddy on 10/4/16.
//  Copyright © 2016 TKO Solutions. All rights reserved.
//

import UIKit

class GameboardViewController: UIViewController {
  
  var viewModel = GameboardViewModel()

  @IBOutlet private weak var gridView: UIView! { didSet {
    viewModel.assignGridView(gridView)
  }}
  
  @IBOutlet private weak var controlBar: ControlBarView! { didSet {
    viewModel.game.assignControlBar(controlBar.viewModel)
    viewModel.setControlBarClosure()
    viewModel.game.controlBar.parentViewController = self
  }}
}
