//
//  FTUEViewController.swift
//  Slider
//
//  Created by Tom Nelson on 1/21/17.
//  Copyright © 2017 TKO Solutions. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation

class FTUEViewController: UIViewController {
  
  @IBOutlet private var panelOne: UIView!
  @IBOutlet private var panelTwo: UIView!
  @IBOutlet private weak var videoView: UIView!
  @IBOutlet private var panelThree: UIView!
  
  @IBOutlet private weak var pageOneWelcome: UILabel! { didSet {
    pageOneWelcome.font = gameSize.largeFont
  }}
  @IBOutlet private weak var pageOneText: UILabel! { didSet {
    pageOneText.font = gameSize.font
  }}
  @IBOutlet private var pageTwoText: UILabel! { didSet {
    pageTwoText.font = gameSize.font
  }}
  @IBOutlet private var pageThreeText: UILabel! { didSet {
    pageThreeText.font = gameSize.font
  }}
  @IBOutlet fileprivate weak var panelsView: UIScrollView! { didSet {
      panelsView.delegate = self
  }}

  @IBOutlet fileprivate weak var pageControl: UIPageControl! { didSet {
    pageControl.numberOfPages = 4
    pageControl.currentPage = 0
  }}
  
  @IBAction func userPaged(_ sender: UIPageControl) {
    let page = pageControl.currentPage
    let width = UIScreen.main.bounds.width
    let point = CGPoint(x: Int(width) * page, y: 0)
    panelsView.setContentOffset(point, animated: true)
  }
  
  var offsetStart: CGFloat!
  var offsetFinish: CGFloat!
  
  override func viewDidLoad() {
    addPanels()
    
    super.viewDidLoad()
  }
  
  func gameboard() -> UIViewController {
    return UIStoryboard(name: "Gameboard", bundle: nil).instantiateInitialViewController()!
  }
  
  private func addPanels() {
    let width = UIScreen.main.bounds.width
    let height = UIScreen.main.bounds.height
    let intro = self.gameboard()
    offsetStart = 2 * width
    offsetFinish = 2.5 * width + 1
    
    panelsView.frame = CGRect(x: 0, y: 0, width: width, height: height)
    panelOne.frame = CGRect(x: 0, y: 0, width: width, height: height)
    panelTwo.frame = CGRect(x: width, y: 0, width: width, height: height)
    panelThree.frame = CGRect(x: width * 2, y: 0, width: width, height: height)
    intro.view.frame = CGRect(x: width * 3, y: 0, width: width, height: height)
    
    panelsView.addSubview(panelOne)
    panelsView.addSubview(panelTwo)
    panelsView.addSubview(panelThree)
    panelsView.addSubview(intro.view)
    
    panelsView.contentSize = CGSize(
      width: width * CGFloat(pageControl.numberOfPages),
      height: height
    )
  }

  fileprivate func isLastPage(_ currentPage: Int) -> Bool {
    return currentPage == (pageControl.numberOfPages - 1)
  }
  
  func playVideo() {
    videoView.alpha = 1
    guard let videoURL = Bundle.main.url(forResource: "Slider2", withExtension: "mov") else { return }
    let player = AVPlayer(url: videoURL)
    let playerLayer = AVPlayerLayer(player: player)
    playerLayer.frame = self.videoView!.bounds
    self.videoView!.layer.addSublayer(playerLayer)
    player.play()
    
    UIView.animate(withDuration: 0.5, delay: 9, options: [], animations: {
      self.videoView.alpha = 0
    }, completion: nil)
  }
}

extension FTUEViewController: UIScrollViewDelegate {
  func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
    let width = UIScreen.main.bounds.width
    let page = floor(panelsView.contentOffset.x / width)
    pageControl.currentPage = Int(page)
    
    if pageControl.currentPage == 1 { self.playVideo() }
    
    guard isLastPage(pageControl.currentPage) else { return }
    
    guard let gameboardViewController = self.gameboard() as? GameboardViewController else { return }
    UIApplication.shared.keyWindow?.rootViewController = gameboardViewController
    gameboardViewController.viewModel.FTUECompleted = true
  }
  
  func scrollViewDidScroll(_ scrollView: UIScrollView) {
    var alpha: CGFloat
    
    switch panelsView.contentOffset.x {
    case offsetFinish...CGFloat.greatestFiniteMagnitude: pageControl.alpha = 0
    case offsetStart..<offsetFinish:
      alpha = 1 - (panelsView.contentOffset.x - offsetStart) / (offsetStart / 4)
      pageControl.alpha = alpha
    default: ()
    }
  }
}
