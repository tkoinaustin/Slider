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

  @IBOutlet private weak var gradientView: UIView!
  @IBOutlet private weak var gridView: UIView! { didSet {
    viewModel.assignGridView(gridView)
  }}
  
  @IBOutlet private weak var controlBar: ControlBarView! { didSet {
    viewModel.assignControlBar(controlBar.viewModel)
    viewModel.setControlBarClosure()
    viewModel.controlBar.parentViewController = self
    viewModel.controlBar.addNotifications()
  }}
  
  override func viewDidLoad() {
    super.viewDidLoad()
    viewModel.assignParent(self)
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    viewModel.fillGradient(gradientView)
    viewModel.startGame()
  }
}
