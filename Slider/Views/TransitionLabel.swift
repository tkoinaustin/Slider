//
//  TransitionLabel.swift
//  Slider
//
//  Created by Tom Nelson on 12/4/16.
//  Copyright © 2016 TKO Solutions. All rights reserved.
//

import UIKit
class TransitionLabel: UIView {
  
  var color: UIColor! { didSet {
    self.underLabel.backgroundColor = color
    self.overLabel.backgroundColor = color
  }}
  
  var displayFont: UIFont! { didSet {
    self.underLabel.font = displayFont
    self.overLabel.font = displayFont
  }}
    
  var text: String? { didSet {
    if let text = text { setLabel(text) }
  }}
  
  var underLabel = UILabel()
  var overLabel = UILabel()

  private func setLabel(_ text: String) {
    self.underLabel.text = text
    UIView.animate(withDuration: 0.33, animations: {
      self.overLabel.alpha = 0
      self.underLabel.alpha = 1
    }, completion: { _ in
      self.overLabel.text = text
      self.overLabel.alpha = 1
      self.underLabel.alpha = 0
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
    self.addSubview(underLabel)
    self.addSubview(overLabel)
    self.underLabel.textColor = UIColor.secondaryLabel
    self.overLabel.textColor = UIColor.secondaryLabel
    self.underLabel.textAlignment = .center
    self.overLabel.textAlignment = .center

    underLabel.translatesAutoresizingMaskIntoConstraints = false
    overLabel.translatesAutoresizingMaskIntoConstraints = false
    let margins = layoutMarginsGuide
    
    underLabel.topAnchor.constraint(equalTo: margins.topAnchor, constant: -8).isActive = true
    underLabel.bottomAnchor.constraint(equalTo: margins.bottomAnchor, constant: 8).isActive = true
    underLabel.leadingAnchor.constraint(equalTo: margins.leadingAnchor, constant: -8).isActive = true
    underLabel.trailingAnchor.constraint(equalTo:margins.trailingAnchor, constant: 8).isActive = true
    overLabel.topAnchor.constraint(equalTo: margins.topAnchor, constant: -8).isActive = true
    overLabel.bottomAnchor.constraint(equalTo: margins.bottomAnchor, constant: 8).isActive = true
    overLabel.leadingAnchor.constraint(equalTo: margins.leadingAnchor, constant: -8).isActive = true
    overLabel.trailingAnchor.constraint(equalTo:margins.trailingAnchor, constant: 8).isActive = true
  }
}
