//
//  ReplayBoardViewController.swift
//  Slider
//
//  Created by Tom Nelson on 12/13/16.
//  Copyright © 2016 TKO Solutions. All rights reserved.
//

import UIKit

class ReplayBoardViewController: UIViewController {
  
  var viewModel = ReplayViewModel() 
  
  var replayText: String = ""
  var index: Int!
  
  @IBOutlet private weak var replayLabel: UILabel! { didSet {
    replayLabel.text = replayText
  }}
  
  @IBOutlet private weak var borderView: BorderView! { didSet {
    borderView.alpha = 0
    borderView.borderColor = Color.steel
  }}
  
  @IBOutlet private weak var replayGrid: UIView! { didSet {
    viewModel.assignGridView(replayGrid)
    replayGrid.widthAnchor.constraint(equalTo: borderView.gameboardLocation.widthAnchor).isActive = true
    replayGrid.heightAnchor.constraint(equalTo: borderView.gameboardLocation.heightAnchor).isActive = true
    replayGrid.centerXAnchor.constraint(equalTo: borderView.gameboardLocation.centerXAnchor).isActive = true
    replayGrid.centerYAnchor.constraint(equalTo: borderView.gameboardLocation.centerYAnchor).isActive = true
  }}
  
  @IBOutlet private weak var gradientHeight: NSLayoutConstraint! { didSet {
      gradientHeight.constant = gameSize.border
  }}

  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    UIView.animate(withDuration: 0.5, animations: {
      self.borderView.alpha = 1
    }, completion: { _ in
      self.viewModel.loadBlocks()
    })
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.title = "Game \(index! + 1)"
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    viewModel.stopTimer()
  }
}
