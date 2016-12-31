//
//  TabShowSegue.swift
//  Slider
//
//  Created by Tom Nelson on 12/31/16.
//  Copyright © 2016 TKO Solutions. All rights reserved.
//

import UIKit

class TabShowSegue: UIStoryboardSegue {
  override func perform() {
    let nav = source.navigationController!
    let dest = destination as! UINavigationController
    
    nav.pushViewController(dest.viewControllers[0], animated: true)
  }
}
