//
//  TransitionLabel.swift
//  Slider
//
//  Created by Tom Nelson on 12/4/16.
//  Copyright © 2016 TKO Solutions. All rights reserved.
//

import UIKit
class TransitionLabel: UILabel {
  
  var color: UIColor! { didSet {
    newLabel.backgroundColor = color
  }}
  
  var displayFont: UIFont! { didSet {
    self.font = displayFont
    newLabel.font = displayFont
  }}
  
  var newValue: String!
  
  override var text: String? { didSet {
    if let text = text { setLabel(text) }
  }}
  
  var newLabel = UILabel()
  
  func setLabel(_ text: String) {
    newValue = text
    UIView.animate(withDuration: 0.00, animations: {
      self.newLabel.alpha = 0
    }, completion: { _ in
      self.newLabel.text = self.newValue
        UIView.animate(withDuration: 0.00, animations: {
            self.newLabel.alpha = 1
        })
    })
  }
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    setup()
  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    setup()
  }
  
  func setup() {
    self.textColor = UIColor.clear

    self.addSubview(newLabel)
    self.newLabel.textAlignment = self.textAlignment
    self.newLabel.font = font
    self.newLabel.textColor = UIColor.secondaryLabel

    newLabel.translatesAutoresizingMaskIntoConstraints = false
    let margins = layoutMarginsGuide
    
    newLabel.topAnchor.constraint(equalTo: margins.topAnchor, constant: -8).isActive = true
    newLabel.bottomAnchor.constraint(equalTo: margins.bottomAnchor, constant: 8).isActive = true
    newLabel.leadingAnchor.constraint(equalTo: margins.leadingAnchor, constant: -8).isActive = true
    newLabel.trailingAnchor.constraint(equalTo:margins.trailingAnchor, constant: 8).isActive = true
  }
}
