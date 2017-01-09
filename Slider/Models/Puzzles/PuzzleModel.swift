//
//  PuzzleModel.swift
//  Slider
//
//  Created by Tom Nelson on 1/8/17.
//  Copyright © 2017 TKO Solutions. All rights reserved.
//

import UIKit

class PuzzleModel: NSObject, NSCoding {
  private(set) var name = ""
  private(set) var puzzleClass = ""
  private(set) var index: Int = 0
  private(set) var grid = [[Int]]()
  private(set) var bestMoves = 0
  private(set) var won = false
  
  override init() {
    name = ""
    puzzleClass = ""
    index = 0
    grid = [[Int]]()
    bestMoves = 0
    won = false
  }
  
  required init(name: String, puzzleClass: String, index: Int, grid: [[Int]], bestMoves: Int, won: Bool) {
    self.name = name
    self.puzzleClass = puzzleClass
    self.index = index
    self.grid = grid
    self.bestMoves = bestMoves
    self.won = won
  }
  
  required convenience init?(coder aDecoder: NSCoder) {
    self.init()
    if let name = aDecoder.decodeObject(forKey: "name") as? String { self.name = name }
    if let puzzleClass = aDecoder.decodeObject(forKey: "puzzleClass") as? String { self.puzzleClass = puzzleClass }
    index = aDecoder.decodeInteger(forKey: "index")
    bestMoves = aDecoder.decodeInteger(forKey: "bestMoves")
    won = aDecoder.decodeBool(forKey: "won")
  }
  
  func encode(with aCoder: NSCoder) {
    aCoder.encode(index, forKey: "name")
    aCoder.encode(index, forKey: "puzzleClass")
    aCoder.encode(index, forKey: "index")
    aCoder.encode(bestMoves, forKey: "bestMoves")
    aCoder.encode(won, forKey: "won")
  }
  
}
