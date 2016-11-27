//
//  Archiver.swift
//  Slider
//
//  Created by Mac Daddy on 11/13/16.
//  Copyright © 2016 TKO Solutions. All rights reserved.
//

import UIKit

enum Model: String {
  case move, history, game, puzzle
  
  func modelClass() -> AnyClass {
    switch self {
    case .move: return GameMoveData.self
    case .history: return HistoryModel.self
    case .game: return GameModel.self
    case .puzzle: return Puzzles.self
    }
  }
}

class Archiver {
  static func dataFilePath(_ model: Model) -> String {
    let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
    let filepath = path[0].appendingPathComponent(model.rawValue)
    return filepath.path
  }
  
  static func store(data: Any, model: Model) -> Bool {
    let file = Archiver.dataFilePath(model)
    return NSKeyedArchiver.archiveRootObject(data, toFile: file)
  }
  
  static func retrieve(model: Model) -> Any? {
    let file = Archiver.dataFilePath(model)
    guard let master = NSKeyedUnarchiver.unarchiveObject(withFile: file) else { return nil }
    return master
  }
}
