//
//  FTUEViewController.swift
//  Slider
//
//  Created by Tom Nelson on 1/21/17.
//  Copyright © 2017 TKO Solutions. All rights reserved.
//

import UIKit

class FTUEViewController: UIViewController {
  
  @IBOutlet private var panelOne: UIView!
  @IBOutlet private var panelTwo: UIView!
  @IBOutlet private var panelThree: UIView!
  
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
}

extension FTUEViewController: UIScrollViewDelegate {
  func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
    let width = UIScreen.main.bounds.width
    let page = floor(panelsView.contentOffset.x / width)
    pageControl.currentPage = Int(page)
    
    guard isLastPage(pageControl.currentPage) else { return }

    guard let gameboardViewController = self.gameboard() as? GameboardViewController else { return }
    UIApplication.shared.keyWindow?.rootViewController = gameboardViewController
    gameboardViewController.viewModel.FTUECompleted = true
}
  
  func scrollViewDidScroll(_ scrollView: UIScrollView) {
    var alpha: CGFloat
    
    switch panelsView.contentOffset.x {
    case 801...CGFloat.greatestFiniteMagnitude: ()
    case 640...800:
      alpha = 1 - (panelsView.contentOffset.x - 640) / 160
      pageControl.alpha = alpha
    default: ()
    }
  }
}
