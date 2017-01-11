//
//  IntroViewController.swift
//  Slider
//
//  Created by Mac Daddy on 9/24/16.
//  Copyright © 2016 TKO Solutions. All rights reserved.
//

import UIKit

class IntroViewController: UIViewController {
  
  @IBOutlet private weak var logoView: UIImageView!
  @IBOutlet private weak var continueButton: UIButton!
  
  override func viewDidLoad() {
    let height = view.frame.height
    let transform = CGAffineTransform(translationX: 0, y: height)
    continueButton.transform = transform
  }
  
  override func viewWillAppear(_ animated: Bool) {
    let height = view.frame.height
    let transform = CGAffineTransform(translationX: 0, y: -height)
    UIView.animate(withDuration: 1.5, animations: {
      self.continueButton.transform = CGAffineTransform.identity
      self.logoView.transform = transform
    })
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    gameSize = .small
    guard let historyStore = Archiver.retrieve(model: .historyStore)
      as? [String: GameHistoryModel] else { return }
    HistoryStoreModel.shared.load(historyStore)
  }
}
