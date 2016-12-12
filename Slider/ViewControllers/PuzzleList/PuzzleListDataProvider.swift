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
  private var parent: PuzzleListViewController!

  func assignParent(_ parent: PuzzleListViewController) {
    self.parent = parent
  }

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
      let gameModel = store[indexPath.row]
      let name = gameModel.name
      cell.puzzleLabel?.text = name
      cell.historyButton.setTitle("History", for: .normal)
      cell.historyButton.isEnabled = true
      cell.historyButton.addTarget(self,
                                   action: #selector(buttonAction(sender:)),
      for: UIControlEvents.touchUpInside)
      cell.historyButton.tag = indexPath.row
      
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
  
  func  buttonAction(sender: UIButton) {
    let row = sender.tag
    let name = store[row].name
    let historyModel = allGames.history(for: name)
    let gameModels = historyModel.history
    let gameModel = gameModels[0]
    let moves = gameModel.moveData
    print("button action: history count for \(name) is \(gameModels.count)")
    
    let cnt = gameModels.count
    let games = cnt == 1 ? "1 game" : "\(cnt) games"
    let notify = UIAlertController.init(title: name,
                                        message: "has \(games) in history",
                                        preferredStyle: .actionSheet)
    let okAction = UIAlertAction(title: "OK", style: .default)
    notify.addAction(okAction)
    self.parent.present(notify, animated: true, completion: nil)
  }
  

}
