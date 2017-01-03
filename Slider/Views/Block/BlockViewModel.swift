//
//  BlockViewModel.swift
//  Slider
//
//  Created by Mac Daddy on 9/27/16.
//  Copyright © 2016 TKO Solutions. All rights reserved.
//

import UIKit

enum Direction: Int {
  case up = 0, right, down, left
  
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

class BlockViewModel {
  var index: Int!
  weak var model: BlockModel!

  private(set) var center: CGPoint!
  var startingCenter: CGPoint!
  var bounds: CGRect!
  var canvas: CGSize! { didSet {
    bounds = setBounds()
  }}
  
  var updateBlockUI: (() -> ()) = {}
  var nextStep: (() -> ()) = {}
  var fadeIn: (() -> ()) = {}
  var exitOffScreen: (() -> ()) = {}
  
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
  
  func moveOffBoard() {
    guard index == 1 else { return }
    placeBlock(point: CGPoint(x: 0.5, y: 1.3))
    self.exitOffScreen()
  }
  
  func placeBlock(point: CGPoint) {
    center = CGPoint(x: point.x * canvas.width, y: point.y * canvas.height)
  }
  
  func setCenter(newCenter: CGPoint) {
    center = newCenter
    updateBlockUI()
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
