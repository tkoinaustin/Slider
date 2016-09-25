//
//  BlockView.swift
//  Slider
//
//  Created by Mac Daddy on 9/25/16.
//  Copyright © 2016 TKO Solutions. All rights reserved.
//

import UIKit

@IBDesignable

class BlockView: UIView, NibLoadable {
  let ibTag = 666
  
  @IBOutlet weak var imageView: UIImageView!
    
  func setup() {
    let pan = UIPanGestureRecognizer(target: self, action: #selector(pan(_:)))
    self.addGestureRecognizer(pan)
  }
  
  override func awakeAfter(using aDecoder: NSCoder) -> Any? {
    return customAwakeAfter(superAwakeAfter: { return super.awakeAfter(using: aDecoder) })
  }
  
  override func prepareForInterfaceBuilder() {
    makeIBDesignable()
  }

  func pan(_ panRecognizer: UIPanGestureRecognizer) {
    
    let translation = panRecognizer.translation(in: self)
    center = CGPoint(x: center.x + translation.x, y: center.y + translation.y)
    
    panRecognizer.setTranslation(CGPoint(x: 0, y: 0), in: self)
  }
}
