//
//  Delay.swift
//  Slider
//
//  Created by Tom Nelson on 12/30/16.
//  Copyright © 2016 TKO Solutions. All rights reserved.
//

import UIKit

struct Delay {
  static func by(_ amount: Double, completion: @escaping () -> ()) {
    DispatchQueue.main.asyncAfter(deadline: .now() + amount) {
     completion()
    }
  }
}
