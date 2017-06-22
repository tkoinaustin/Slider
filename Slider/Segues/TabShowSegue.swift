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
    guard let nav = source.navigationController else { return }
    guard let dest = destination as? UINavigationController else { return }
    
    nav.pushViewController(dest.viewControllers[0], animated: true)
  }
}
