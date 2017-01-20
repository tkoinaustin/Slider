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

  @IBOutlet private weak var bannerAdView: BannerAdView!
  @IBOutlet private weak var borderView: BorderView! { didSet {
    borderView.borderColor = Color.lightPurple
  }}
  
  @IBOutlet private weak var gridView: UIView! { didSet {
    viewModel.assignGridView(gridView)
    gridView.widthAnchor.constraint(equalTo: borderView.gameboardLocation.widthAnchor).isActive = true
    gridView.heightAnchor.constraint(equalTo: borderView.gameboardLocation.heightAnchor).isActive = true
    gridView.centerXAnchor.constraint(equalTo: borderView.gameboardLocation.centerXAnchor).isActive = true
    gridView.centerYAnchor.constraint(equalTo: borderView.gameboardLocation.centerYAnchor).isActive = true
  }}
  
  @IBOutlet private weak var controlBarView: ControlBarView! { didSet {
    controlBarView.size = gameSize
    viewModel.assignControlBar(controlBarView.viewModel)
    viewModel.setControlBarClosure()
    viewModel.controlBar.parentViewController = self
  }}

  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    viewModel.startGame()
    bannerAdView.start()
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if let view = sender as? UIButton { segue.destination.popoverPresentationController?.sourceView = view }
  }
}
