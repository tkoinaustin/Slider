//
//  IntroSegue.swift
//  Slider
//
//  Created by Tom Nelson on 12/31/16.
//  Copyright © 2016 TKO Solutions. All rights reserved.
//

import UIKit

class IntroSegue: UIStoryboardSegue {
  
  override func perform() {
//    let width = UIScreen.main.bounds.width
//    let left = CGAffineTransform(translationX: -width, y: 0)
    let tiny = CGAffineTransform.identity.scaledBy(x: 0, y: 0)
    destination.view.transform = tiny
    source.view.addSubview(destination.view)
    
    UIView.transition(
      with: UIApplication.shared.keyWindow!,
      duration: 0.75,
      options: UIViewAnimationOptions(),
      animations: {
        self.destination.view.transform = CGAffineTransform.identity
    },
      completion: { _ in
        self.destination.view.removeFromSuperview()
        UIApplication.shared.keyWindow?.rootViewController =
          self.destination
    })
  }
}
