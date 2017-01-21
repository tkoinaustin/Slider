//
//  FTUEViewController.swift
//  Slider
//
//  Created by Tom Nelson on 1/21/17.
//  Copyright © 2017 TKO Solutions. All rights reserved.
//

import UIKit

class FTUEViewController: UIViewController {
  
  @IBOutlet var panelOne: UIView!
  @IBOutlet var panelTwo: UIView!
  @IBOutlet var panelThree: UIView!
  
  @IBOutlet weak var panelsView: UIScrollView! { didSet {
      panelsView.delegate = self
  }}
  
  @IBOutlet weak var pageControl: UIPageControl! { didSet {
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
  
  func intro() -> UIViewController {
    return UIStoryboard(name: "Gameboard", bundle: nil).instantiateInitialViewController()!
  }
  
  private func addPanels() {
    let width = UIScreen.main.bounds.width
    let height = UIScreen.main.bounds.height
    let intro = self.intro()
    
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

  private func isLastPage(_ currentPage: Int) -> Bool {
    return currentPage == (pageControl.numberOfPages - 1)
  }
  
  private func disableScrolling() {
    panelsView.isPagingEnabled = false
    panelsView.isScrollEnabled = false
  }
  
  fileprivate func handleLastPage() {
    guard pageControl.currentPage == pageControl.numberOfPages - 1  else { return }
    
    disableScrolling()
    hidePageControl(then: { [unowned self] in
      UIApplication.shared.keyWindow?.rootViewController = self.intro()
    })
  }
  
  private func hidePageControl(then completion: @escaping () -> Void) {
    let fadeOut = UIViewPropertyAnimator(duration: 0.5, curve: .easeIn, animations: {
      [unowned self] in
      self.pageControl.alpha = 0
    })
    
    fadeOut.addCompletion { _ in completion() }
    
    fadeOut.startAnimation()
  }
}


extension FTUEViewController: UIScrollViewDelegate {
  func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
    let width = UIScreen.main.bounds.width
    let page = floor(panelsView.contentOffset.x / width)
    pageControl.currentPage = Int(page)
    
    handleLastPage()
  }

}
