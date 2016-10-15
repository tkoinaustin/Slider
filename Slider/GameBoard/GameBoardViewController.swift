//
//  GameBoardViewController.swift
//  Slider
//
//  Created by Mac Daddy on 10/4/16.
//  Copyright © 2016 TKO Solutions. All rights reserved.
//

import UIKit

class GameBoardViewController: UIViewController {
  
  var grid = GridViewModel()

  @IBOutlet weak var gridView: UIView!
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    
    grid.load(size: gridView.frame.size)
    
    let _ = CodedBlockView.get(parent: gridView, grid: grid, index: 1)
    let _ = CodedBlockView.get(parent: gridView, grid: grid, index: 2)
    let _ = CodedBlockView.get(parent: gridView, grid: grid, index: 3)
    let _ = CodedBlockView.get(parent: gridView, grid: grid, index: 4)
    let _ = CodedBlockView.get(parent: gridView, grid: grid, index: 5)
    let _ = CodedBlockView.get(parent: gridView, grid: grid, index: 6)
    let _ = CodedBlockView.get(parent: gridView, grid: grid, index: 7)
    let _ = CodedBlockView.get(parent: gridView, grid: grid, index: 8)
    let _ = CodedBlockView.get(parent: gridView, grid: grid, index: 9)
    let _ = CodedBlockView.get(parent: gridView, grid: grid, index: 10)
    let _ = CodedBlockView.get(parent: gridView, grid: grid, index: 11)
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    print("GameBoardViewController: didReceiveMemoryWarning()")
  }
  
}
