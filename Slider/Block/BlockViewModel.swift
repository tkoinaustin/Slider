//
//  BlockViewModel.swift
//  Slider
//
//  Created by Mac Daddy on 9/27/16.
//  Copyright © 2016 TKO Solutions. All rights reserved.
//

import UIKit

enum Direction {
  case up, right, down, left
}

enum BlockType {
  case small, wide, tall, big
}

class BlockViewModel {
  var index: Int!
  var model: BlockModel!
  var direction: Direction?

  var center: CGPoint!
  var bounds: CGRect!
  var canvas: CGSize! { didSet {
    bounds = setBounds()
  }}
  

  var moveFinished: (() -> ()) = {}
  var updateUI: (() -> ()) = {}
  var notifyDirection: ((_: Direction, _: Int) -> ()) = {_,_ in }
  
  var type: BlockType = .small { didSet {
    guard let _ = canvas else { return }
    bounds = setBounds()
  }}
  
  init(model: BlockModel) {
    index = model.index!
    type = model.type!
    self.model = model
    model.viewModel = self
  }
  
  func placeBlock(point: CGPoint) {
    center = CGPoint(x: point.x * canvas.width, y: point.y * canvas.height)
  }
  
  private func setBounds() -> CGRect {
    var wide = canvas.width / 4
    var tall = canvas.height / 5
    switch type {
    case .wide: wide *= 2
    case .tall: tall *= 2
    case .big: wide *= 2; tall *= 2
    case .small: break
    }
    return CGRect(x: 0, y: 0, width: wide, height: tall)
  }
  
  func start(at: CGPoint) {
    //maybe here we should check for legal directions, touch down
  }
  
  func moving(amount: CGPoint) {
    if let travelDirection = direction {
      model.moveByAmount(direction: travelDirection, amount: amount)
    } else {
      if let dir = setDirection(x: amount.x, y: amount.y){
        guard model.canMove(direction: dir) else { return }
        
        print("----- direction was set to \(dir) ------")
        self.direction = dir
        notifyDirection(dir, self.index!)
      }
    }
  }

  func finished() {
    guard let direction = direction else { return }
    
    if model.canMove(direction: direction) {
      model.setFinalPosition(direction)
    }
    self.direction = nil
    moveFinished()
  }
  
  func moveByAmount(direction: Direction, amount: CGPoint) {
    switch direction {
    case .up, .down:
      center = CGPoint(x: center.x, y: center.y + amount.y)
    case .left, .right:
      center = CGPoint(x: center.x + amount.x, y: center.y)
    }
    updateUI()
  }

  private func setDirection(x: CGFloat, y: CGFloat) -> Direction? {
    let threshhold: CGFloat = 2
    guard abs(x) > threshhold || abs(y) > threshhold else { return nil }
    if abs(x) > abs(y) {
      return x > 0 ? .right : .left
    } else {
      return y > 0 ? .down : .up
    }
  }
}
