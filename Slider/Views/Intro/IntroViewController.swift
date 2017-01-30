//
//  IntroViewController.swift
//  Slider
//
//  Created by Mac Daddy on 9/24/16.
//  Copyright © 2016 TKO Solutions. All rights reserved.
//

import UIKit

class IntroViewController: UIViewController {
  
  @IBOutlet private weak var continueButton: UIButton!
  @IBOutlet private weak var logoLabel: UILabel!
  
  @IBAction func launchApp(_ sender: UIButton) {
    if needFTUE() {
      UserDefaults.standard.set(false, forKey: "FTUE")
      performSegue(withIdentifier: "FTUESegue", sender: self)
    } else {
      performSegue(withIdentifier: "gameboardSegue", sender: nil)
    }
  }
  
  override func viewDidLoad() {
    let height = view.frame.height
    let transform = CGAffineTransform(translationX: 0, y: height)
    continueButton.transform = transform
  }
  
  func needFTUE() -> Bool {
    guard let _ = UserDefaults.standard.value(forKey: "FTUE") else { return true }
    return false
  }
  
  override func viewWillAppear(_ animated: Bool) {
    let height = view.frame.height
    
    switch height {
    case 1024...CGFloat.greatestFiniteMagnitude: gameSize = .large
    case 667...1023: gameSize = .medium
    default: gameSize = .small
    }
    
    let transform = CGAffineTransform(translationX: 0, y: -height)
    UIView.animate(withDuration: 1.5, animations: {
      self.continueButton.transform = CGAffineTransform.identity
      self.logoLabel.transform = transform
    })
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "gameboardSegue" {
      let dest = segue.destination as? GameboardViewController
      let viewModel = dest?.viewModel
      viewModel?.FTUECompleted = true
    }
    
    guard let historyStore = Archiver.retrieve(model: .historyStore)
      as? [String: GameHistoryModel] else { return }
    HistoryStoreModel.shared.load(historyStore)
  }
}
