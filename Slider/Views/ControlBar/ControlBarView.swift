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
  
  @IBOutlet private weak var puzzle: UIButton!
  @IBOutlet private weak var moveNumber: TransitionLabel!
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
  
  @IBAction func save(_ sender: UIButton) {
    viewModel.saveIt()
  }
  
  @IBAction func load(_ sender: UIButton) {
    viewModel.loadIt()
  }
  
  func setup() {
    viewModel.updateControlBarUI = { _ in
      self.updateUI()
    }
    updateUI()
  }

  override func awakeAfter(using aDecoder: NSCoder) -> Any? {
    return customAwakeAfter(superAwakeAfter: { return super.awakeAfter(using: aDecoder) })
  }
  
  override func prepareForInterfaceBuilder() {
    makeIBDesignable()
  }
  
  func updateUI() {
    back.isEnabled = viewModel.backEnabled
    forward.isEnabled = viewModel.forwardEnabled
    puzzle.setTitle(viewModel.puzzleLabel, for: .normal)
    moveNumber.text = viewModel.moveNumber.description
    UIView.animate(withDuration: 0.2, animations: {
      self.moveNumber.alpha = 0
    }, completion: { _ in
      self.moveNumber.text = self.viewModel.moveNumber.description
      UIView.animate(withDuration: 0.2, animations: {
      self.moveNumber.alpha = 1
      })
    })
  }
}
