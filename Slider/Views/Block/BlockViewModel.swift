//
//  BlockViewModel.swift
//  Slider
//
//  Created by Mac Daddy on 9/27/16.
//  Copyright © 2016 TKO Solutions. All rights reserved.
//

import UIKit

enum Direction: Int {
  //swiftlint:disable identifier_name
  case up = 0, right, down, left
  //swiftlint:enable identifier_name
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
  var swipeEnabled = true

  private(set) var center: CGPoint!
  var startingCenter: CGPoint!
  var bounds: CGRect!
  var canvas: CGSize! { didSet {
    bounds = setBounds()
  }}
  
  var updateBlockUI: ((TimeInterval) -> Void) = { _ in }
  var nextStep: (() -> Void) = {}
  var fadeIn: (() -> Void) = {}
  var exitOffScreen: (() -> Void) = {}
  var spinOffScreen: (() -> Void) = {}
  var fadeOffScreen: (() -> Void) = {}
  var reset: (() -> Void) = {}
  var fadeOutAndRemove: (() -> Void) = {}
  var blockMoveStarted: (() -> Void) = {}

  var type: BlockType = .small { didSet {
    guard canvas != nil else { return }
    bounds = setBounds()
  }}
  
  init(model: BlockModel) {
    index = model.index!
    type = model.type!
    self.model = model
    model.viewModel = self
  }
  
  func moveOffBoard() {
    swipeEnabled = false
    if index == 1 {
        placeBlock(point: CGPoint(x: 0.5, y: 1.0))
        self.exitOffScreen()
    } else {
        self.fadeOffScreen()
    }
  }
    
    func moveOffBoardInitialWin() {
      swipeEnabled = false
      if index == 1 {
          placeBlock(point: CGPoint(x: 0.5, y: 1.0))
          self.exitOffScreen()
      } else {
          self.spinOffScreen()
      }
    }

  func placeBlock(point: CGPoint) {
    center = CGPoint(x: point.x * canvas.width, y: point.y * canvas.height)
  }
  
  func setCenter(newCenter: CGPoint) {
    center = newCenter
    updateBlockUI(0.2)
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
  
  func remove() {
    fadeOutAndRemove()
  }
}
