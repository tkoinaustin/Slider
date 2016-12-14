//
//  ReplayBoardViewController.swift
//  Slider
//
//  Created by Tom Nelson on 12/13/16.
//  Copyright © 2016 TKO Solutions. All rights reserved.
//

import UIKit

class ReplayBoardViewController: UIViewController {
  
  var replayText: String = ""
  
  @IBOutlet weak var replayLabel: UILabel! { didSet {
    replayLabel.text = replayText
  }}
  
}
