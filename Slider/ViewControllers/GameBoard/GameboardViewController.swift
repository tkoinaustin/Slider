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

  @IBOutlet private weak var gradientView: UIView! { didSet {
    gradientView.backgroundColor = UIColor(patternImage: UIImage(named: "opaque gradient")!)
    gradientView.clipsToBounds = true
  }}
  
  @IBOutlet weak var borderView: BorderView! { didSet {
    borderView.borderColor = Color.lightPurple
    }}
  
  @IBOutlet private weak var gridView: UIView! { didSet {
    viewModel.assignGridView(gridView)
  }}
  
  @IBOutlet private weak var controlBarView: ControlBarView! { didSet {
    viewModel.assignControlBar(controlBarView.viewModel)
    viewModel.setControlBarClosure()
    viewModel.controlBar.parentViewController = self
  }}

  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    viewModel.startGame()
  }
}
