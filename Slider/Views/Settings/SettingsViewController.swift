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

  @IBOutlet var gratuityButton: UIButton!
  @IBOutlet var gratuityLabel: UILabel!

  override func viewDidLoad() {
    super.viewDidLoad()

    self.title = "Settings"
    navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel,
                                                       target: self,
                                                       action: #selector(dismissController))
    
    if !Gratuity.store.showBannerAds { loadThankYou() }
  }
  
  @IBAction func instructionsAction(_ sender: UIButton) {
    saveGame()
    
    switch UIDevice.current.userInterfaceIdiom {
    case .pad:
      dismissController()
      showFTUE()
    default:
      navigationController?.setNavigationBarHidden(true, animated: true)
    }
  }
  
  @IBAction func gratuityAction(_ sender: UIButton) {
    dismissController()
    Gratuity.store.buyProduct()
  }
  
  @IBAction func restoreAction(_ sender: UIButton) {
    dismissController()
    Gratuity.store.restorePurchases()
  }
  
  func loadThankYou() {
    gratuityLabel.text = "Thank you for supporting indie development"
    gratuityButton.alpha = 0
  }
  
  func dismissController() {
    dismiss(animated: true, completion: nil)
  }

}
