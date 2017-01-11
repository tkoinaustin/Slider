//
//  ControlBarView.swift
//  Slider
//
//  Created by Tom Nelson on 11/11/16.
//  Copyright © 2016 TKO Solutions. All rights reserved.
//

import UIKit

@IBDesignable

class ControlBarView: UIView, XibLoadable {
  let ibTag = 13
  let viewModel = ControlBarViewModel()
  
  var size: GameSize! { didSet {
    puzzle.titleLabel?.font = size.font
    reset.titleLabel?.font = size.font
    puzzleName.font = size.font
    moveNumber.displayFont = size.font
    timerView.labelView.displayFont = size.font
  }}
  
  @IBOutlet private weak var puzzle: UIButton!
  @IBOutlet private weak var reset: UIButton!
  @IBOutlet private weak var moveNumber: TransitionLabel!
  
  @IBOutlet private weak var puzzleName: UILabel!
  @IBOutlet private weak var back: UIButton!
  @IBOutlet private weak var forward: UIButton!
  @IBOutlet private weak var timerView: TimerView! { didSet {
    timerView.viewModel = viewModel
  }}
  
  @IBAction func backAction(_ sender: UIButton) {
    viewModel.backward()
  }
  
  @IBAction func forwardAction(_ sender: UIButton) {
    viewModel.forward()
  }
  
  @IBAction func puzzleList(_ sender: UIButton) {
    viewModel.displayPuzzleList()
  }
  
  @IBAction func resetAction(_ sender: UIButton) {
    viewModel.resetCurrentGame()
  }
  
  func setup() {
    viewModel.updateControlBarUI = { _ in
      self.updateUI()
    }
    
    size = .large
    updateUI()
    viewModel.addNotifications()
  }

  override func awakeAfter(using aDecoder: NSCoder) -> Any? {
    return customAwakeAfter(superAwakeAfter: { return super.awakeAfter(using: aDecoder) })
  }
  
  override func prepareForInterfaceBuilder() {
    makeIBDesignable()
  }
  
  func updateUI() {
    print("update control bar UI")
    back.isEnabled = viewModel.backEnabled
    forward.isEnabled = viewModel.forwardEnabled
    reset.isEnabled = viewModel.resetEnabled
    puzzle.setTitle(viewModel.puzzleLabel, for: .normal)
    if let move = viewModel.moveNumber { moveNumber.text = move.description }
    
    switch viewModel.timerState {
    case .start:
      timerView.start()
    case .stop:
      timerView.stop()
    case .reset:
      timerView.reset()
      viewModel.timerState = .start
    }
  }
}
