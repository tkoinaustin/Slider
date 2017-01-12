//
//  TimerView.swift
//  Slider
//
//  Created by Tom Nelson on 11/30/16.
//  Copyright © 2016 TKO Solutions. All rights reserved.
//

import UIKit

enum TimerState {
  case start, stop, reset
}

@IBDesignable

class TimerView: UIView {
  fileprivate var hour = ""
  fileprivate var minute = ""
  fileprivate var second =  ""
  fileprivate var timer: Timer?
  var labelView: TransitionLabel!
  var viewModel: ControlBarViewModel! { didSet {
    viewModel.updateTimerState = updateForTimerState(_:)
  }}

  public override init(frame: CGRect) {
    super.init(frame: frame)
    setup()
  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    setup()
  }
  
  func setup() {
    labelView = TransitionLabel(frame: frame)
    
    self.addSubview(labelView)
    labelView.translatesAutoresizingMaskIntoConstraints = false
    let margins = layoutMarginsGuide
    
    labelView.topAnchor.constraint(equalTo: margins.topAnchor, constant: -8).isActive = true
    labelView.bottomAnchor.constraint(equalTo: margins.bottomAnchor, constant: 8).isActive = true
    labelView.leadingAnchor.constraint(equalTo: margins.leadingAnchor, constant: -8).isActive = true
    labelView.trailingAnchor.constraint(equalTo:margins.trailingAnchor, constant: 8).isActive = true
    labelView.text = "00:00"
    start()
  }
  
  func updateForTimerState(_ state: TimerState) {
    switch state {
    case .start: start()
    case .stop: stop()
    case .reset: reset()
    }
  }
  
  func start() {
    if let _ = timer { return }
    timer = Timer.scheduledTimer(timeInterval: 1,
                                 target: self,
                                 selector: #selector(fired),
                                 userInfo: nil,
                                 repeats: true)
  }
  
  func stop() {
    timer?.invalidate()
    timer = nil
  }
  
  func reset() {
    stop()
    viewModel.timerCount = 0
    setDisplay(viewModel.timerCount)
    start()
  }
  
  func fired() {
    // do the timer thing
    viewModel.timerCount += 1
    setDisplay(viewModel.timerCount)
  }
  
  func setDisplay(_ timerCount: TimeInterval) {
    hour = (Int(viewModel.timerCount / 3600)).description
    minute = (Int(viewModel.timerCount) % 3600 / 60).description
    second = (Int(viewModel.timerCount) % 60).description
    
    hour = hour != "0" ? "\(hour):" : ""
    if minute.lengthOfBytes(using: .ascii) == 1 { minute = "0\(minute)" }
    if second.lengthOfBytes(using: .ascii) == 1 { second = "0\(second)" }
    
    let time = "\(hour)\(minute):\(second)"
    labelView.text = time
  }

}
