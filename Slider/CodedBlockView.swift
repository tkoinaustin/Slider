//
//  CodedBlockView.swift
//  Slider
//
//  Created by Mac Daddy on 9/25/16.
//  Copyright © 2016 TKO Solutions. All rights reserved.
//

import UIKit

class CodedBlockView: UIView {
  
  var imageView = UIImageView()

  public override init(frame: CGRect) {
    super.init(frame: frame)
    setup()
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func setup() {
    self.addSubview(imageView)
    
    let pan = UIPanGestureRecognizer(target: self, action: #selector(pan(_:)))
    self.addGestureRecognizer(pan)
    
    imageView.translatesAutoresizingMaskIntoConstraints = false
    let margins = layoutMarginsGuide
    
    imageView.topAnchor.constraint(equalTo: margins.topAnchor).isActive = true
    imageView.bottomAnchor.constraint(equalTo: margins.bottomAnchor).isActive = true
    imageView.leadingAnchor.constraint(equalTo: margins.leadingAnchor).isActive = true
    imageView.trailingAnchor.constraint(equalTo:margins.trailingAnchor).isActive = true
    
    imageView.image = UIImage(named: "superman")
  }
  
  func pan(_ panRecognizer: UIPanGestureRecognizer) {
    
    let translation = panRecognizer.translation(in: self)
    center = CGPoint(x: center.x + translation.x, y: center.y + translation.y)
    
    panRecognizer.setTranslation(CGPoint(x: 0, y: 0), in: self)
  }
}
