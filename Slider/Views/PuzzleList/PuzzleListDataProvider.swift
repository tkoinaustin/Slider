//
//  PuzzleListDataProvider.swift
//  Slider
//
//  Created by Mac Daddy on 10/29/16.
//  Copyright © 2016 TKO Solutions. All rights reserved.
//

import UIKit

class PuzzleListDataProvider: NSObject, UITableViewDataSource {
  
  var store = Puzzles().klotski
  var allGames = HistoryStoreModel.shared
  
  func registerCellsForTableView(_ tableView: UITableView) {
    tableView.register(PuzzleListCell.self, forCellReuseIdentifier: "cell")
  }

  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return store.count
  }
  
  func tableView(_ tableView: UITableView,
                 cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
    let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
    
    if let cell = cell as? PuzzleListCell {
      cell.puzzleLabel?.text = "Puzzle \(indexPath.row)"
      cell.historyButton.setTitle("History", for: .normal)
      cell.historyButton.isEnabled = true

      let name = store[indexPath.row].name
      switch allGames.history(for: name).state {
      case .neverPlayed:
        cell.neverPlayed()
      case .played(let won):
        if won { cell.won() }
        else { cell.notWon() }
      }
    }
    
    return cell
  }
}
