//
//  SliderViewController.swift
//  Slider
//
//  Created by Mac Daddy on 9/24/16.
//  Copyright © 2016 TKO Solutions. All rights reserved.
//

import UIKit

class SliderViewController: UIViewController {
    
  @IBOutlet weak var supermanImageView: UIImageView! { didSet {
    let pan = UIPanGestureRecognizer(target: self, action: #selector(pan(_:)))
    supermanImageView.addGestureRecognizer(pan)
  }}
  
  override func viewDidLoad() {
    let frame = CGRect(x: 0, y: 0, width: 256, height: 176)
    let image = CodedBlockView.init(frame: frame)
    image.center = view.center
    view.addSubview(image)
  }
  
  func pan(_ panRecognizer: UIPanGestureRecognizer) {
    guard let panView = supermanImageView else { return }
    
    let translation = panRecognizer.translation(in: view)
    panView.center = CGPoint(x: panView.center.x + translation.x, y: panView.center.y + translation.y)
    
    panRecognizer.setTranslation(CGPoint(x: 0, y: 0), in: view)
  }
}
