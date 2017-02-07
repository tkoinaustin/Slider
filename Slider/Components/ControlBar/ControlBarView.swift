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
    buttonHeight.constant = gameSize.buttonSize
  }}
  
  @IBOutlet private weak var settings: UIButton! { didSet {
    viewModel.settingsButton = settings
  }}

  @IBOutlet private weak var puzzle: UIButton!
  @IBOutlet private weak var reset: UIButton!
  @IBOutlet private weak var moveNumber: TransitionLabel!
  @IBOutlet private weak var buttonHeight: NSLayoutConstraint!

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
  
  @IBAction func settingsAction(_ sender: UIButton) {
    viewModel.displaySettings()
  }
  
  @IBAction func resetAction(_ sender: UIButton) {
    viewModel.resetCurrentGame()
  }
  
  func setup() {
    viewModel.updateControlBarUI = { [unowned self] _ in
      self.updateUI()
    }
    
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
    viewModel.puzzleSource = convert(puzzle.frame, to: superview)
    back.isEnabled = viewModel.backEnabled
    forward.isEnabled = viewModel.forwardEnabled
    reset.isEnabled = viewModel.resetEnabled
    puzzleName.text = viewModel.puzzleLabel
    if let move = viewModel.moveNumber { moveNumber.text = move.description }
    
    switch viewModel.timerState {
    case .start, .initialize:
      puzzle.isEnabled = true
      settings.isEnabled = true
    case .stop:
      timerView.stop()
      puzzle.isEnabled = false
      settings.isEnabled = false
    case .reset:
      timerView.reset()
      puzzle.isEnabled = true
      settings.isEnabled = true
    }
  }
}
