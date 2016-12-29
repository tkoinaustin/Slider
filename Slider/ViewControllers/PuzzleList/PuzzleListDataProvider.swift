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
  var gameModels = [GameModel]()
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
    gameModels = historyModel.history

    // swiftlint:disable force_cast
    let storyboard = UIStoryboard(name: "HistoryList", bundle: Bundle.main)
    
    let navController: UINavigationController = storyboard.instantiateViewController(withIdentifier: "historyListNavController")
        as! UINavigationController
    
    let historyListViewController: HistoryListViewController = navController.viewControllers[0]
      as! HistoryListViewController
    historyListViewController.data = gameModels
    historyListViewController.preferredContentSize = CGSize(width: 400, height: 3000)

    parent.navigationController?.pushViewController(historyListViewController, animated: true)
  }
}
