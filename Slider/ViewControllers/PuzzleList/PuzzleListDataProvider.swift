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
  private weak var parent: PuzzleListViewController!

  func assignParent(_ parent: PuzzleListViewController) {
    self.parent = parent
  }

  func registerCellsForTableView(_ tableView: UITableView) {
    tableView.register(PuzzleListCell.self, forCellReuseIdentifier: "puzzleListReuseIdentifier")
  }

  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return store.count
  }
  
  func tableView(_ tableView: UITableView,
                 cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
    let cell = tableView.dequeueReusableCell(withIdentifier: "puzzleListReuseIdentifier", for: indexPath)
    
    if let cell = cell as? PuzzleListCell {
      let gameModel = store[indexPath.row]
      let name = gameModel.name
      cell.puzzleLabel?.text = name
      cell.historyButton.setTitle("History", for: .normal)
      cell.historyButton.isEnabled = true
      if indexPath.row == parent.currentIndex { cell.selected() }
      cell.historyButton.addTarget(self,
                                   action: #selector(buttonAction(sender:)),
                                   for: UIControl.Event.touchUpInside)
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
  
  @objc func  buttonAction(sender: UIButton) {
    let row = sender.tag
    let name = store[row].name
    let historyModel = allGames.history(for: name)
    gameModels = historyModel.history

    let storyboard = UIStoryboard(name: "HistoryList", bundle: Bundle.main)
    
    guard let navController: UINavigationController =
      storyboard.instantiateViewController(withIdentifier: "historyListNavController")
        as? UINavigationController else { return }
    
    guard let historyListViewController: HistoryListViewController = navController.viewControllers[0]
      as? HistoryListViewController else { return }
    
    historyListViewController.data = gameModels

    parent.navigationController?.pushViewController(historyListViewController, animated: true)
  }
}
