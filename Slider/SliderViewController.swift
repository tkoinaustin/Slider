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
  }}
  
  override func viewDidLoad() {
    let pan = UIPanGestureRecognizer(target: self, action: #selector(pan(_:)))
    pan.delegate = self
    view.addGestureRecognizer(pan)
  }
}

extension SliderViewController: UIGestureRecognizerDelegate {
  func pan(_ panRecognizer: UIPanGestureRecognizer) {
    guard let panView = supermanImageView else { return }
    
    let transation = panRecognizer.translation(in: view)
    panView.center = CGPoint(x: panView.center.x + transation.x, y: panView.center.y + transation.y)
    
    panRecognizer.setTranslation(CGPoint(x: 0, y: 0), in: view)
  }
  
}
