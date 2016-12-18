//
//  GameHistoryModel.swift
//  Slider
//
//  Created by Mac Daddy on 11/13/16.
//  Copyright © 2016 TKO Solutions. All rights reserved.
//

import UIKit

class GameHistoryModel: NSObject, NSCoding {
  var name: String!
  var index: Int = 0
  var bestMoves: Int = 0
  var bestTime: TimeInterval = 1_000_000
  var state: GameState = .neverPlayed
  var history = [GameModel]()
  
  override var description: String {
    var played = false
    var winner = false
    
    switch state {
    case .neverPlayed: break
    case .played (let won):
      played = true
      winner = won
    }
    
    var desc = "\(name!) played:\(played) won:\(winner)"
    for game in history {
      desc += ("\n     \(game)")
    }
    return desc
  }

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
    let history1 = aDecoder.decodeObject(forKey: "history")
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
  
//  var description: String {
//    return ""
//  }
  
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
    
    history.append(game)
  }
}
