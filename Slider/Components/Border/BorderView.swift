//
//  BorderView.swift
//  Slider
//
//  Created by Tom Nelson on 1/10/17.
//  Copyright © 2017 TKO Solutions. All rights reserved.
//

import UIKit

class BorderView: UIView, XibLoadable {
  let ibTag = 18
  
  var borderColor: UIColor! { didSet {
    for border in borders { border.backgroundColor = borderColor }
  }}
  
  @IBOutlet private weak var borderWidth: NSLayoutConstraint! { didSet {
      borderWidth.constant = gameSize.border
  }}
  
  @IBOutlet private weak var sideBorderWidth: NSLayoutConstraint! { didSet {
    sideBorderWidth.constant = gameSize.border
  }}

  @IBOutlet private weak var bottomLeft: UIView! { didSet {
      bottomLeft.layer.cornerRadius = gameSize.corner
      bottomLeft.clipsToBounds = true
  }}
  @IBOutlet private weak var bottomRight: UIView! { didSet {
    bottomRight.layer.cornerRadius = gameSize.corner
    bottomRight.clipsToBounds = true
  }}

  @IBOutlet weak var gameboardLocation: UIView!
  
  @IBOutlet private var borders: [UIView]!
  
  func setup() {
    layer.cornerRadius = gameSize.corner
    clipsToBounds = true
  }
  
  override func awakeAfter(using aDecoder: NSCoder) -> Any? {
    return customAwakeAfter(superAwakeAfter: { return super.awakeAfter(using: aDecoder) })
  }
  
  override func prepareForInterfaceBuilder() {
    makeIBDesignable()
  }
}
