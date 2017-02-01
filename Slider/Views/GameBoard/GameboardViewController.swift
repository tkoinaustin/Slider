//
//  GameboardViewController.swift
//  Slider
//
//  Created by Mac Daddy on 10/4/16.
//  Copyright © 2016 TKO Solutions. All rights reserved.
//

import UIKit

class GameboardViewController: UIViewController {
  
  var viewModel = GameboardViewModel()

  @IBOutlet private weak var bannerAdView: BannerAdView! { didSet {
    switch viewModel.showBannerAds {
    case true:
      topLayoutToGridConstraint.isActive = false
    case false:
      bannerAdView.alpha = 0
      bannerAdToGridConstraint.isActive = false
    }
  }}
  
  @IBOutlet private weak var borderView: BorderView! { didSet {
    borderView.borderColor = Color.lightPurple
  }}
  
  @IBOutlet private weak var gridView: UIView! { didSet {
    viewModel.assignGridView(gridView)
    gridView.widthAnchor.constraint(equalTo: borderView.gameboardLocation.widthAnchor).isActive = true
    gridView.heightAnchor.constraint(equalTo: borderView.gameboardLocation.heightAnchor).isActive = true
    gridView.centerXAnchor.constraint(equalTo: borderView.gameboardLocation.centerXAnchor).isActive = true
    gridView.centerYAnchor.constraint(equalTo: borderView.gameboardLocation.centerYAnchor).isActive = true
    gridView.setNeedsLayout()
    gridView.layoutIfNeeded()
  }}
  
  @IBOutlet private weak var controlBarView: ControlBarView! { didSet {
    controlBarView.size = gameSize
    viewModel.assignControlBar(controlBarView.viewModel)
    viewModel.setControlBarClosure()
    viewModel.controlBar.parentViewController = self
  }}

  @IBOutlet private var bannerAdToGridConstraint: NSLayoutConstraint!
  @IBOutlet private var topLayoutToGridConstraint: NSLayoutConstraint!

  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    viewModel.startGame()
    bannerAdView.start()
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    guard segue.identifier == "settingsSegue" else { return }
    
    segue.destination.popoverPresentationController?.sourceView = sender as? UIButton
    let navController = segue.destination as? UINavigationController
    let dest = navController?.viewControllers[0] as? SettingsViewController
    
    dest?.saveGame = { [unowned self] _ in
      self.viewModel.game.gameTime = self.viewModel.controlBar.timerCount
      self.viewModel.saveGame()
    }
    dest?.showFTUE = { [unowned self] _ in
      self.performSegue(withIdentifier: "FTUESegue", sender: nil)
    }
  }
}
