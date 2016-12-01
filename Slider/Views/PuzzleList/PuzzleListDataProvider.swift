//
//  PuzzleListDataProvider.swift
//  Slider
//
//  Created by Mac Daddy on 10/29/16.
//  Copyright © 2016 TKO Solutions. All rights reserved.
//

import UIKit

class PuzzleListDataProvider: NSObject, UITableViewDataSource {
  
  var store = Puzzles().gameboards
  
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
      cell.completedLabel?.text = "Completed: \(indexPath.row)"
    }
    
    return cell
  }
}
