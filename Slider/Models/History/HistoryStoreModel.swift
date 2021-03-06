//
//  HistoryStoreModel.swift
//  Slider
//
//  Created by Tom Nelson on 12/17/16.
//  Copyright © 2016 TKO Solutions. All rights reserved.
//

import UIKit

class HistoryStoreModel: NSObject, NSCoding {
  private(set) var allGames = [String: GameHistoryModel]()
  static let shared = HistoryStoreModel()
  
  override var description: String {
    var desc = ""
    for (_, value) in allGames.sorted(by: { $0.value.index < $1.value.index }) {
      desc += ("\n\(value)\n")
    }
    return desc
  }
  
  func encode(with aCoder: NSCoder) {
    aCoder.encode(allGames, forKey: "allGames")
  }
  
  required convenience init?(coder aDecoder: NSCoder) {
    self.init()
    if let allGames = aDecoder.decodeObject(forKey: "allGames")
      as? [String : GameHistoryModel] { self.allGames = allGames }
  }
  
  func load(_ data: [String: GameHistoryModel]) {
    allGames = data
  }
  
  func addGame(_ game: GameModel, to puzzle: String) -> Bool {
    guard let history = allGames[puzzle] else { return false }
    history.addGame(game: game)
    
    return true
  }
  
  func history(for puzzle: String) -> GameHistoryModel {
    if let history = allGames[puzzle] { return history }
    
    let parts = puzzle.components(separatedBy: " ")
    let index = Int(parts[1])
    let newPuzzle = GameHistoryModel()
    newPuzzle.name = puzzle
    newPuzzle.index = index!
    allGames[puzzle] = newPuzzle
    return newPuzzle
  }
  
  func contains(_ game: GameModel) -> Bool {
    let games = self.history(for: game.name)
    for gameHistory in games.history where game.datePlayed == gameHistory.datePlayed {
        return true
    }
    return false
  }
}
