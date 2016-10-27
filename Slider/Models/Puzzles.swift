//
//  Puzzles.swift
//  Slider
//
//  Created by Tom Nelson on 10/26/16.
//  Copyright © 2016 TKO Solutions. All rights reserved.
//

import UIKit

struct Gameboard {
  var grid = [[Int]]()
  var bestMoves = 0
  var completed = false
}

class Puzzles {
  private var gridLayout0 = [[2,3,4,5],[2,3,4,5],[7,8,6,6],[1,1,0,0],[1,1,9,10]]
  private var gridLayout1 = [[2,3,4,5],[2,3,4,5],[7,8,0,0],[1,1,6,6],[1,1,9,10]]
  private var gridLayout2 = [[2,3,4,5],[2,3,4,5],[0,0,7,8],[1,1,6,6],[1,1,9,10]]
  private var gridLayout3 = [[2,3,4,5],[2,3,4,5],[1,1,7,8],[1,1,6,6],[0,0,9,10]]
  private var gridLayout4 = [[2,3,4,5],[2,3,4,5],[1,1,7,8],[1,1,6,6],[9,0,0,10]]
  private var gridLayout5 = [[2,3,4,5],[2,3,4,5],[1,1,7,8],[1,1,6,6],[9,10,0,0]]
  
  
  private var gridLayout6 = [[2,1,1,3],[2,1,1,3],[4,5,5,6],[4,7,8,6],[9,0,0,10]]
  private var gridLayout7 = [[2,1,1,3],[2,1,1,3],[4,5,5,6],[4,0,0,6],[9,7,8,10]]
  private var gridLayout8 = [[2,5,5,3],[2,1,1,3],[4,1,1,6],[4,7,8,6],[9,0,0,10]]
  private var gridLayout9 = [[2,7,8,3],[2,5,5,3],[4,1,1,6],[4,1,1,6],[9,0,0,10]]
  
  var gameboards: [[[Int]]]?
  
  init () {
    setGameboards()
  }
  
  func setGameboards() {
    gameboards = [gridLayout0, gridLayout1, gridLayout2, gridLayout3, gridLayout4,
                  gridLayout5, gridLayout6, gridLayout7, gridLayout8, gridLayout9]
  }

}
