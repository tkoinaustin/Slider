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

enum MoveDistance {
  case none, one, two
}

let EmptySpace = 0


class BlockViewModel: Hashable {
  var index: Int!
  var neighbors: [Direction: Set<BlockViewModel>]!
  var origin = Coordinate(row:0, col:0)
  var model: BlockModel!

  var center: CGPoint!
  var bounds: CGRect!
  var canvas: CGSize! { didSet {
    bounds = setBounds()
  }}
  
  var direction: Direction?
  var startingCenter: CGPoint?

  var moveFinished: (() -> ()) = {}
  var updateUI: (() -> ()) = {}
  var notifyDirection: ((_: Direction, _: Int) -> ()) = {_,_ in }
  var canMove: ((_: Direction, _: Int) -> (Bool))! // = {_,_ -> Bool in }
  
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

  init(index: Int){
    self.index = index
    resetNeighbors()
  }
  
  init(model: BlockModel) {
    index = model.index!
    type = model.type!
    origin = model.origin
  }
  
  var hashValue: Int {
    return index
  }
  
  func resetNeighbors() {
    neighbors = [.up: Set<BlockViewModel>(), .right: Set<BlockViewModel>(), .down: Set<BlockViewModel>(), .left: Set<BlockViewModel>()]
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
    startingCenter = at
    //maybe here we should check for legal directions, touch down
    
  }
  
  func moving(amount: CGPoint) {
    if let travelDirection = direction {
      moveByAmount(direction: travelDirection, amount: amount)
    } else {
      if let dir = setDirection(x: amount.x, y: amount.y){
        guard canMove(dir, index!) else { return }
        
        print("----- direction was set to \(dir) ------")
        self.direction = dir
        notifyDirection(dir, self.index!)
      }
    }
  }

  func finished() {
    guard let direction = direction else { return }
    
    if canMove(direction, index!) {
      setFinalPosition(direction: direction)
    }
    self.direction = nil
    print("----- finished ------")
    moveFinished()
  }
  
  func setFinalPosition(direction: Direction) {
    for neighbor in neighbors[direction]! {
      guard neighbor.index != EmptySpace else { continue }
      neighbor.setFinalPosition(direction: direction)
    }
    updateOrigin(direction: direction)
    placeBlock(point: GridConstants.blockCenter(row: origin.row, col: origin.col, type: type))
    updateUI()
  }
  
  func updateOrigin(direction: Direction) {
    guard index != EmptySpace else { return }
    guard let _ = neighbors[direction] else { return }
    
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
    // canMove needs to be GameModel
    guard canMove(direction, index!) else { return }

    switch direction {
    case .up, .down:
      center = CGPoint(x: center.x, y: center.y + amount.y)
    case .left, .right:
      center = CGPoint(x: center.x + amount.x, y: center.y)
    }
    // this needs to be moved up to GridViewModel and GameModel
    guard let neighbors = model.neighbors(direction: direction) else { return }
    for neighbor in neighbors {
      neighbor.moveByAmount(direction: direction, amount: amount)
      neighbor.updateUI()
//      print("neighbor \(neighbor.index!) moving \(amount)")
    }
  }
  
  private func setDirection(x: CGFloat, y: CGFloat) -> Direction? {
    let threshhold: CGFloat = 2
    guard abs(x) > threshhold || abs(y) > threshhold else { return nil }
    if abs(x) > abs(y) {
      return x > 0 ? .right : .left
    } else {
      return y > 0 ? .down : .up
    }
    // direction is set, update models with new knowledge
    // this info need to go to GameModel
  }

//  func neighbors(direction: Direction) -> Set<BlockViewModel>? {
//    guard let blocks = neighbors[direction] else { return nil }
//    return blocks
//  }
  
  // this needs to be moved to the Model classes
//  func canMove(direction: Direction) -> Bool {
//    guard let blocks = neighbors[direction] else { print("guard failed"); return false }
//    if blocks.count == 0 { print("no neighbors"); return false }
//    
//    for block in blocks {
//      if block.index == EmptySpace {
//        print("empty space")
//        /* move legal, check other blocks */
//      } else if !block.canMove(direction: direction) {
//        print("checking block \(block.index)")
//        return false
//      }
//    }
//    
//    return true
//  }
  
//  func canMove(direction: Direction, amount: MoveDistance) -> MoveDistance {
//    guard let blocks = neighbors[direction] else { print("guard failed"); return .none }
//    if blocks.count == 0 { print("no neighbors"); return .none }
//    var distance = amount
//    
//    for block in blocks {
//      if block.index == EmptySpace {
//        print("empty space")
//        distance = amount == .none ? .one : .two
//        /* move legal, check other blocks */
//      } else if block.canMove(direction: direction, amount: distance) == .none {
//        print("checking block \(block.index)")
//        return .none
//      }
//    }
//    
//    return distance
//  }
//  
  func addNeighbor(direction: Direction, block: BlockViewModel) {
    neighbors[direction]?.insert(block)
  }
  
}

extension BlockViewModel: Equatable { }
func == (lhs: BlockViewModel, rhs: BlockViewModel) -> Bool {
  return lhs.index == rhs.index
}
