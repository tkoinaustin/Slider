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

class BlockViewModel: Hashable {
  var index: Int!
  var origin = Coordinate(row:0, col:0)
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
  
  var coordinates: String {
    var rtn: String = "\nblock \(index!):\n"
    switch type {
    case .small:
      rtn += "[\(origin.row),\(origin.col)]"
    case .wide:
      rtn += "[\(origin.row),\(origin.col))] [\(origin.row),\(origin.col)+1)]"
    case .tall:
      rtn += "[\(origin.row),\(origin.col))]\n[\(origin.row+1),\(origin.col))]"
    case .big:
      rtn += "[\(origin.row),\(origin.col))] [\(origin.row),\(origin.col)+1)]\n[\(origin.row+1),\(origin.col))] [\(origin.row+1),\(origin.col)+1)]"
    }
    return rtn
  }
  
  init(model: BlockModel) {
    index = model.index!
    type = model.type!
    origin = model.origin
    self.model = model
    model.viewModel = self
  }
  
  var hashValue: Int {
    return index
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
        guard canMove(direction: dir) else { return }
        
        print("----- direction was set to \(dir) ------")
        self.direction = dir
        notifyDirection(dir, self.index!)
      }
    }
  }

  func finished() {
    guard let direction = direction else { return }
    
    if canMove(direction: direction) {
      setFinalPosition(direction: direction)
    }
    self.direction = nil
    print("----- finished ------")
    moveFinished()
  }
  
  func setFinalPosition(direction: Direction) {
    updateOrigin(direction: direction)
    placeBlock(point: GridConstants.blockCenter(row: origin.row, col: origin.col, type: type))
    updateUI()
    
    guard let neighbors = model.neighbors(direction) else { return }
    for neighbor in neighbors {
      guard neighbor.index != EmptySpace else { continue }
      neighbor.viewModel.setFinalPosition(direction: direction)
    }
  }
  
  func updateOrigin(direction: Direction) {
    guard index != EmptySpace else { return }
    guard let _ = model.neighbors(direction) else { return }
    
    switch direction {
    case .up:
      origin.row -= 1
      assert(origin.row >= 0, "row < 0")
    case .down:
      origin.row += 1
      assert(origin.row < Rows, "row > Rows")
    case .left:
      origin.col -= 1
      assert(origin.col >= 0,  "col < 0")
    case .right:
      origin.col += 1
      assert(origin.col < Columns," col > Columns")
    }
    print("block \(index!) origin: (\(origin.row),\(origin.col)))")
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
  
  func canMove(direction: Direction) -> Bool {
    return model.canMove(direction: direction)
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

extension BlockViewModel: Equatable { }
func == (lhs: BlockViewModel, rhs: BlockViewModel) -> Bool {
  return lhs.index == rhs.index
}
