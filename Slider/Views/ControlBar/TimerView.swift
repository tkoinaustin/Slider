//
//  TimerView.swift
//  Slider
//
//  Created by Tom Nelson on 11/30/16.
//  Copyright © 2016 TKO Solutions. All rights reserved.
//

import UIKit

@IBDesignable

class TimerView: UIView {
  fileprivate var hour = ""
  fileprivate var minute = ""
  fileprivate var second =  ""
  fileprivate var timer: Timer?
  var count = 0
  var labelView: UILabel!
  
  public override init(frame: CGRect) {
    super.init(frame: frame)
    setup()
  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    setup()
  }
  
  func setup() {
    labelView = UILabel(frame: frame)
    
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
  
  func start() {
    timer = Timer.scheduledTimer(timeInterval: 1,
                                 target: self,
                                 selector: #selector(fired),
                                 userInfo: nil,
                                 repeats: true)
  }
  
  func stop() {
    timer?.invalidate()
  }
  
  func fired() {
    // do the timer thing
    count += 1
    
    hour = (count / 3600).description
    minute = (count % 3600 / 60).description
    second = (count % 60).description
    
    if hour.lengthOfBytes(using: .ascii) == 1 { hour = "0\(hour)" }
    if minute.lengthOfBytes(using: .ascii) == 1 { minute = "0\(minute)" }
    if second.lengthOfBytes(using: .ascii) == 1 { second = "0\(second)" }
    
    let time = "\(minute):\(second)"
    labelView.text = time
  }

}