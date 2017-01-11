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

  @IBOutlet private weak var gradientView: UIView! { didSet {
    gradientView.backgroundColor = UIColor(patternImage: gameSize.gradient!)
    gradientView.clipsToBounds = true
  }}
  
  @IBOutlet private weak var replayLabel: UILabel! { didSet {
    replayLabel.text = replayText
  }}
  
  @IBOutlet private weak var borderView: BorderView! { didSet {
      borderView.alpha = 0
    borderView.borderColor = Color.red
  }}
  
  @IBOutlet private weak var replayGrid: UIView! { didSet {
    viewModel.assignGridView(replayGrid)
  }}
  
  @IBOutlet private weak var gradientHeight: NSLayoutConstraint! { didSet {
      gradientHeight.constant = gameSize.border
  }}

  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    viewModel.loadBlocks()
    UIView.animate(withDuration: 0.2, animations: { self.borderView.alpha = 1 })
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.title = "Game \(index! + 1)"
    
    viewModel.dismiss = {
      self.dismiss(animated: true, completion: nil)
    }
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    viewModel.stopTimer()
  }
}
