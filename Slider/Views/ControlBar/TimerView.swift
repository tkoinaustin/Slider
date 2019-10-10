//
//  TimerView.swift
//  Slider
//
//  Created by Tom Nelson on 11/30/16.
//  Copyright © 2016 TKO Solutions. All rights reserved.
//

import UIKit

enum TimerState {
  case initialize, start, stop, reset, enableControls
}

@IBDesignable

class TimerView: UIView {
  fileprivate var hour = ""
  fileprivate var minute = ""
  fileprivate var second =  ""
  fileprivate var timer: Timer?
  var minutesLabel = UILabel()
  var minutesUnderLabel = UILabel()
  var secondsLabel = UILabel()
  var secondsUnderLabel = UILabel()
  var viewModel: ControlBarViewModel! { didSet {
    viewModel.updateTimerState = updateForTimerState(_:)
  }}

    var color: UIColor! { didSet {
        self.secondsLabel.backgroundColor = color
        self.secondsUnderLabel.backgroundColor = color
        self.minutesLabel.backgroundColor = color
        self.minutesUnderLabel.backgroundColor = color
    }}
    
    var displayFont: UIFont! { didSet {
        self.secondsLabel.font = displayFont
        self.secondsUnderLabel.font = displayFont
        self.minutesLabel.font = displayFont
        self.minutesUnderLabel.font = displayFont
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
      self.secondsLabel.textColor = .secondaryLabel
      self.secondsUnderLabel.textColor = .secondaryLabel
      self.minutesLabel.textColor = .secondaryLabel
      self.minutesUnderLabel.textColor = .secondaryLabel
      self.addSubview(secondsUnderLabel)
      self.addSubview(secondsLabel)
      self.addSubview(minutesUnderLabel)
      self.addSubview(minutesLabel)
      self.secondsLabel.translatesAutoresizingMaskIntoConstraints = false
      self.secondsUnderLabel.translatesAutoresizingMaskIntoConstraints = false
      self.minutesLabel.translatesAutoresizingMaskIntoConstraints = false
      self.minutesUnderLabel.translatesAutoresizingMaskIntoConstraints = false
      let margins = self.layoutMarginsGuide
      
      self.secondsLabel.topAnchor.constraint(equalTo: margins.topAnchor, constant: -8).isActive = true
      self.secondsUnderLabel.topAnchor.constraint(equalTo: margins.topAnchor, constant: -8).isActive = true
      self.minutesLabel.topAnchor.constraint(equalTo: margins.topAnchor, constant: -8).isActive = true
      self.minutesUnderLabel.topAnchor.constraint(equalTo: margins.topAnchor, constant: -8).isActive = true
      self.secondsLabel.bottomAnchor.constraint(equalTo: margins.bottomAnchor, constant: 8).isActive = true
      self.secondsUnderLabel.bottomAnchor.constraint(equalTo: margins.bottomAnchor, constant: 8).isActive = true
      self.minutesLabel.bottomAnchor.constraint(equalTo: margins.bottomAnchor, constant: 8).isActive = true
      self.minutesUnderLabel.bottomAnchor.constraint(equalTo: margins.bottomAnchor, constant: 8).isActive = true
      self.secondsLabel.leadingAnchor.constraint(equalTo: minutesLabel.trailingAnchor, constant: 0).isActive = true
      self.secondsLabel.leadingAnchor.constraint(equalTo: minutesUnderLabel.trailingAnchor, constant: 0).isActive = true
      self.secondsUnderLabel.leadingAnchor.constraint(equalTo: minutesLabel.trailingAnchor, constant: 0).isActive = true
      self.minutesLabel.leadingAnchor.constraint(equalTo: margins.leadingAnchor, constant: -8).isActive = true
      self.minutesUnderLabel.leadingAnchor.constraint(equalTo: margins.leadingAnchor, constant: -8).isActive = true
      self.secondsLabel.trailingAnchor.constraint(equalTo:margins.trailingAnchor, constant: 8).isActive = true
      self.secondsUnderLabel.trailingAnchor.constraint(equalTo:margins.trailingAnchor, constant: 8).isActive = true
      self.secondsLabel.widthAnchor.constraint(equalToConstant: 35).isActive = true
      self.secondsUnderLabel.widthAnchor.constraint(equalToConstant: 35).isActive = true
      self.secondsUnderLabel.alpha = 0
      self.minutesUnderLabel.alpha = 0
      self.secondsLabel.text = "00"
      self.minutesLabel.text = "00:"
  }
  
  func updateForTimerState(_ state: TimerState) {
    switch state {
        case .initialize: initialize()
        case .start: start()
        case .stop: stop()
        case .reset: reset()
        case .enableControls: ()
    }
  }
  
  func start() {
    if timer != nil { return }
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
  }
  
  func initialize() {
    setDisplay(viewModel.timerCount)
  }
  
    @objc func fired() {
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
    
    self.setMinutes("\(hour)\(minute):")
    self.setSeconds(second)
  }
    
  func setSeconds(_ text: String) {
      self.secondsUnderLabel.text = text
      UIView.animate(withDuration: 0.33, animations: {
        self.secondsLabel.alpha = 0
        self.secondsUnderLabel.alpha = 1
      }, completion: { _ in
        self.secondsLabel.text = text
        self.secondsLabel.alpha = 1
        self.secondsUnderLabel.alpha = 0
      })
    }
    
    func setMinutes(_ text: String) {
      self.minutesUnderLabel.text = text
      UIView.animate(withDuration: 0.33, animations: {
        self.minutesLabel.alpha = 0
        self.minutesUnderLabel.alpha = 1
      }, completion: { _ in
        self.minutesLabel.text = text
        self.minutesLabel.alpha = 1
        self.minutesUnderLabel.alpha = 0
      })
    }

}
