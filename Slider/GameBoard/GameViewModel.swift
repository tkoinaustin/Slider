//
//  GameViewModel.swift
//  Slider
//
//  Created by Mac Daddy on 9/27/16.
//  Copyright © 2016 TKO Solutions. All rights reserved.
//

import UIKit

let Rows = 5
let Columns = 4

class GameViewModel {
  
  private var gridLayout = [[2,2,3,4],[1,1,0,4],[1,1,8,0],[5,7,9,11],[5,10,6,6]]

  private var blocks = [BlockViewModel]()
  private var size: CGSize!
  private var game: GameModel!

  var count: Int {
    return blocks.count
  }
  
//  init () {
//   print("init")
//  }
//  
//  convenience init (gameboard: [[Int]]) {
//    print("convenience init")
//    self.init()
//    game = GameModel(gameBoard: gameboard)
//    // blocks and neighbors have already been set in GameModel, we should just migrate that data from there
//    initBlocks(grid: gameboard)
//    setNeighbors(grid: gameboard)
//  }
  
  func load(size: CGSize) {
    game = GameModel(gameBoard: gridLayout)
    self.size = size
    // blocks and neighbors have already been set in GameModel, we should just migrate that data from there
    initBlocks(grid: gridLayout)
//    setNeighbors(grid: gridLayout)
  }
  
  func block(_ index: Int) -> BlockViewModel {
    guard index < blocks.count && index > 0 else { return blocks[0] }
    
    return blocks[index]
  }
  
  func initBlocks(grid: [[Int]]) {
    // most of this has been pushed into GameModel
    for index in 0..<game.blockCount {
      if let blockModel = game.block(index) {
        let block = BlockViewModel(model: blockModel)
        
        if let size = size { block.canvas = size }
        else { block.canvas = CGSize(width: 320, height: 400) }
        
        block.placeBlock(point: GridConstants.blockCenter(row: block.origin.row, col: block.origin.col, type: block.type))
        
        block.canMove = { (direction, index) -> Bool in
          guard index >= 0 && index < self.blocks.count else { return false }
          guard let gameModel = self.game else { return false }
          guard let blockModel = gameModel.block(index) else {return false }
          
          return (blockModel.canMove(direction: direction))
        }
        
        block.notifyDirection = { direction, block in
          
        }
        
        block.moveFinished = { _ in
          // these will be routed to GameModel.logic and performed there
          self.placeAllBlocks()
          self.game.updateGridForSingleMove()
//          self.setNeighbors(grid: self.gridLayout)
        }
        
        blocks.append(block)
      }
    }
  }
  
//    var indices = Set<Int>()
//    for row in 0..<Rows {
//      for col in 0..<Columns {
//        indices.insert(grid[row][col])
//      }
//    }
//    
//    blocks.removeAll()
//    for index in indices.sorted() {
//      blocks.append(BlockViewModel(index: index))
//    }
//    
//    for row in 0..<Rows {
//      for col in 0..<Columns {
//        let block = blocks[(grid[row][col])]
//        if let _ = block.center { continue }
//        
//        var wide = false
//        var tall = false
//        var blockType: BlockType!
//        
//        if col < Columns - 1 && grid[row][col] == grid[row][col+1] { wide = true }
//        if row < Rows - 1 && grid[row][col] == grid[row+1][col] { tall = true }
//        
//        switch (wide, tall) {
//        case (false, false): blockType = .small
//        case (false, true): blockType = .tall
//        case (true, false): blockType = .wide
//        case (true, true): blockType = .big
//        }
//        
//        if let size = size {
//          block.canvas = size
//        } else {
//          block.canvas = CGSize(width: 320, height: 400)
//        }
//        block.placeBlock(point: GridConstants.blockCenter(row: row, col: col, type: blockType))
//
//        block.type = blockType
//        block.origin.row = row
//        block.origin.col = col
//        
//        block.canMove = { (direction, index) -> Bool in
//          guard index >= 0 && index < self.blocks.count else { return false }
//          guard let gameModel = self.game else { return false }
//          guard let blockModel = gameModel.block(index) else {return false }
//          
//          return (blockModel.canMove(direction: direction))
//        }
//        
//        block.notifyDirection = { direction, block in
//          
//        }
//        
//        block.moveFinished = { _ in
//          // these will be routed to GameModel.logic and performed there
//          self.placeAllBlocks()
//          self.game.updateGridForSingleMove()
//          self.setNeighbors(grid: self.gridLayout)
//        }
//        print("block \(grid[row][col]), center: \(block.center!)")
//      }
//    }
//  }
//
//  func description() -> String {
//    var  desc = ""
//    for row in 0..<Rows {
//      for col in 0..<Columns {
//        desc += "[\(gridLayout[row][col])]"// + col == Columns - 1 ? "\n" : ", "
//        desc += col == Columns - 1 ? "\n" : ", "
//      }
//    }
//    return desc
//  }

    func placeAllBlocks() {
      for block in blocks {
        block.placeBlock(point: GridConstants.blockCenter(row: block.origin.row, col: block.origin.col, type: block.type))
      }
    }

//  func rebuildGrid() {
//    gridLayout = GridConstants.blankLayout
//    for block in blocks {
//      gridLayout[block.origin.row][block.origin.col] = block.index
//      print("gridLayout[\(block.origin.row)][\(block.origin.col)] = \(block.index!)")
//      
//      switch block.type {
//      case .small:
//        continue
//      case .wide:
//        gridLayout[block.origin.row][block.origin.col+1] = block.index
//      case .tall:
//        gridLayout[block.origin.row+1][block.origin.col] = block.index
//      case .big:
//        gridLayout[block.origin.row][block.origin.col+1] = block.index
//        gridLayout[block.origin.row+1][block.origin.col] = block.index
//        gridLayout[block.origin.row+1][block.origin.col+1] = block.index
//      }
//    }
//  }
//  
//  func setNeighbors(grid: [[Int]]) {
//    game.setNeighbors(grid: grid)
//  }
//    guard blocks.count > 0 else { return }
//    
//    for block in blocks { block.resetNeighbors() }
//    
//    for row in 0..<Rows {
//      for col in 0..<Columns {
//        let block = blocks[grid[row][col]]
//
//        if let neighbor = topNeighbor(grid: grid, row: row, col: col) {
//          if block.index != EmptySpace && block.index != neighbor.index {
//            block.addNeighbor(direction: .up, block: neighbor)
//          }
//        }
//        if let neighbor = bottomNeighbor(grid: grid, row: row, col: col) {
//          if block.index != EmptySpace && block.index != neighbor.index {
//            block.addNeighbor(direction: .down, block: neighbor)
//          }
//        }
//        if let neighbor = leftNeighbor(grid: grid, row: row, col: col) {
//          if block.index != EmptySpace && block.index != neighbor.index {
//            block.addNeighbor(direction: .left, block: neighbor)
//          }
//        }
//        if let neighbor = rightNeighbor(grid: grid, row: row, col: col) {
//          if block.index != EmptySpace && block.index != neighbor.index {
//            block.addNeighbor(direction: .right, block: neighbor)
//          }
//        }
//      }
//    }
//  }
//
//  private func topNeighbor(grid: [[Int]], row: Int, col: Int) -> BlockViewModel? {
//    guard row > 0 else { return nil }
//    
//    let index = grid[row-1][col]
//    return blocks[index]
//  }
//  
//  private func bottomNeighbor(grid: [[Int]], row: Int, col: Int) -> BlockViewModel? {
//    guard row < Rows-1 else { return nil }
//    
//    let index = grid[row+1][col]
//    return blocks[index]
//  }
//  
//  private func leftNeighbor(grid: [[Int]], row: Int, col: Int) -> BlockViewModel? {
//    guard col > 0 else { return nil }
//    
//    let index = grid[row][col-1]
//    return blocks[index]
//  }
//
//  private func rightNeighbor(grid: [[Int]], row: Int, col: Int) -> BlockViewModel? {
//    guard col < Columns-1 else { return nil }
//    
//    let index = grid[row][col+1]
//    return blocks[index]
//  }
}
