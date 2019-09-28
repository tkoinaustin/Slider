//
//  SettingsViewController.swift
//  Slider
//
//  Created by Tom Nelson on 1/19/17.
//  Copyright © 2017 TKO Solutions. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {
  
  var saveGame: (() -> Void) = { }
  var showFTUE: (() -> Void) = { }

  @IBOutlet private var gratuityButton: UIButton!
  @IBOutlet private var gratuityLabel: UILabel!
  @IBOutlet private var restoreLabel: UILabel!
  @IBOutlet private var restoreButton: UIButton!
  
  override func viewDidLoad() {
    super.viewDidLoad()

    self.title = "Settings"
    navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel,
                                                       target: self,
                                                       action: #selector(dismissController))
    navigationItem.leftBarButtonItem?.tintColor = UIColor(named: "smallBlock")
  }
  
  @IBAction func instructionsAction(_ sender: UIButton) {
    saveGame()
    
    switch UIDevice.current.userInterfaceIdiom {
    case .pad:
      dismissController()
      showFTUE()
    default: ()
      navigationController?.setNavigationBarHidden(true, animated: true)
    }
  }
  
    @objc func dismissController() {
    dismiss(animated: true, completion: nil)
  }

}
