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
  
  func opposite() -> Direction {
    switch self {
    case .up: return .down
    case .down: return .up
    case .left: return .right
    case .right: return .left
    }
  }
}

enum BlockType {
  case small, wide, tall, big
}

enum Board {
  case moveZeroSpaces, moveOneSpace, moveTwoSpaces
}

class BlockViewModel {
  var index: Int!
  var model: BlockModel!
  var direction: Direction?

  private(set) var center: CGPoint!
  var startingCenter: CGPoint!
  var bounds: CGRect!
  var canvas: CGSize! { didSet {
    bounds = setBounds()
  }}
  
  var updateUI: (() -> ()) = {}
//  var notifyDirection: ((_: Direction, _: Int) -> ()) = {_,_ in }
  
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
  
  func setCenter(newCenter: CGPoint) {
    center = newCenter
    updateUI()
  }
  
  private func setBounds() -> CGRect {
    var wide: CGFloat = canvas.width / 4
    var tall: CGFloat = canvas.height / 5
    model.ppb = wide
    
    switch type {
    case .wide: wide *= 2
    case .tall: tall *= 2
    case .big: wide *= 2; tall *= 2
    case .small: break
    }
    return CGRect(x: 0, y: 0, width: wide, height: tall)
  }
}
