//
//  UIView.swift
//  Slider
//
//  Created by Tom Nelson on 1/6/17.
//  Copyright © 2017 TKO Solutions. All rights reserved.
//

import UIKit

extension UIView {
  var parentViewController: UIViewController? {
    var obj = self.next
    guard obj != nil else { return nil }
    while !(obj?.isKind(of: UIViewController.self))! && obj != nil {
      obj = obj?.next
    }
    
    if let obj = obj as? UIViewController { return obj }
    else { return nil }
  }
}
