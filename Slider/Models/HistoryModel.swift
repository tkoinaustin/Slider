//
//  HistoryModel.swift
//  Slider
//
//  Created by Mac Daddy on 11/13/16.
//  Copyright © 2016 TKO Solutions. All rights reserved.
//

import UIKit

class HistoryStoreModel: NSObject, NSCoding {
  private(set) var allGames = [String: HistoryModel]()
  static let shared = HistoryStoreModel()
  
  func encode(with aCoder: NSCoder) {
    aCoder.encode(allGames, forKey: "allGames")
  }
  
  required convenience init?(coder aDecoder: NSCoder) {
    self.init()
    if let allGames = aDecoder.decodeObject(forKey: "allGames")
      as? [String : HistoryModel] { self.allGames = allGames }
  }
  
  func load(_ data: [String: HistoryModel]) {
    allGames = data
  }
  
  func addGame(_ game: GameModel, to puzzle: String) -> Bool {
    guard let history = allGames[puzzle] else { return false }
    history.addGame(game: game)
    
    return true
  }
  
  func history(for puzzle: String) -> HistoryModel {
    if let history = allGames[puzzle] { return history }
    
    let newPuzzle = HistoryModel()
    newPuzzle.name = puzzle
    allGames[puzzle] = newPuzzle
    return newPuzzle
  }
}

class HistoryModel: NSObject, NSCoding {
  var name: String!
  var index: Int = 0
  var bestMoves: Int = 0
  var bestTime: TimeInterval = 1_000_000
  var state: GameState = .neverPlayed
  var history = [GameModel]()
  
  required convenience init?(coder aDecoder: NSCoder) {
    self.init()
    if let name = aDecoder.decodeObject(forKey: "name")
      as? String { self.name = name }
    index = aDecoder.decodeInteger(forKey: "index")
    bestMoves = aDecoder.decodeInteger(forKey: "bestMoves")
    if let bestTime = aDecoder.decodeObject(forKey: "bestTime")
      as? TimeInterval { self.bestTime = bestTime }
    let played = aDecoder.decodeBool(forKey: "played")
    let winner = aDecoder.decodeBool(forKey: "winner")
    
    switch (played, winner) {
    case (false, _): state = .neverPlayed
    case (true, let winner): state = .played(won: winner)
    }
    let history1 = aDecoder.decodeObject(forKey: "history")// as [GameModel]
    guard let history2 = history1 as? [GameModel] else { return }
    history = history2
  }
  
  func encode(with aCoder: NSCoder) {
    var played = false
    var winner = false
    
    switch state {
    case .neverPlayed: break
    case .played (let won):
      played = true
      winner = won
    }
    
    aCoder.encode(name, forKey: "name")
    aCoder.encode(index, forKey: "index")
    aCoder.encode(bestMoves, forKey: "bestMoves")
    aCoder.encode(bestTime, forKey: "bestTime")
    aCoder.encode(played, forKey: "played")
    aCoder.encode(winner, forKey: "winner")
    aCoder.encode(history, forKey: "history")
  }
  
  func loadHistory() {
  
  }
  
  func saveHistory() {
    // serialize, coder, etc
  }
  
  func addGame(game: GameModel) {
    name = game.name
    index = game.index
    
    if game.gameTime < bestTime { bestTime = game.gameTime }
    if game.moveData.count < bestMoves { bestMoves = game.moveData.count }
    
    switch state {
    case .neverPlayed:
      state = .played(won: game.won)
    case .played:
      if game.won { state = .played(won: true) }
    }
    
    print("history count for \(name) is \(history.count)")
//    if var history = history {
      history.append(game)
//    } else {
//      history = [game]
//    }
    print("appended history count for \(name) is \(history.count)")
  }
}
