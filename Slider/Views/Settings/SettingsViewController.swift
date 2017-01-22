//
//  SettingsViewController.swift
//  Slider
//
//  Created by Tom Nelson on 1/19/17.
//  Copyright © 2017 TKO Solutions. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {
  
  override func viewDidLoad() {
    super.viewDidLoad()

    self.title = "Settings"
    navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel,
                                                       target: self,
                                                       action: #selector(dismissController))
  }
  @IBAction func instructionsAction(_ sender: UIButton) {
    
  }
  
  func dismissController() {
    dismiss(animated: true, completion: nil)
  }

}
