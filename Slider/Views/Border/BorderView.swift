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
  
  @IBOutlet weak var bottomLeft: UIView! { didSet {
      bottomLeft.layer.cornerRadius = 5
      bottomLeft.clipsToBounds = true
  }}
  @IBOutlet weak var bottomRight: UIView! { didSet {
    bottomRight.layer.cornerRadius = 5
    bottomRight.clipsToBounds = true
  }}

  @IBOutlet var borders: [UIView]!
  
  
  func setup() {
    print("BorderView setup")
    layer.cornerRadius = 5
    clipsToBounds = true
    for border in borders { border.backgroundColor = UIColor.red }
  }
  
  override func awakeAfter(using aDecoder: NSCoder) -> Any? {
    return customAwakeAfter(superAwakeAfter: { return super.awakeAfter(using: aDecoder) })
  }
  
  override func prepareForInterfaceBuilder() {
    makeIBDesignable()
  }
  

}
